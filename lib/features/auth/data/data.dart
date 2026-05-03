import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("users");

  // Constant keys to ensure SignUp and SignIn always use identical storage slots
  static const String _keyEmail = 'local_email';
  static const String _keyPass = 'local_password';

  // --- REGISTRATION ---
  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();
    final cleanPass = password.trim();

    try {
      // 1. Create in Firebase Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: cleanPass,
      );

      final String uid = credential.user!.uid;

      // 2. Save to Realtime Database (Cloud)
      await _dbRef.child(uid).set({
        "email": cleanEmail,
        "password": cleanPass,
        "last_updated": ServerValue.timestamp,
      });

      // 3. Save to Local SharedPreferences (For Offline Fallback)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyEmail, cleanEmail);
      await prefs.setString(_keyPass, cleanPass);

      return credential;
    } catch (_) {
      rethrow;
    }
  }

  // --- LOGIN WITH OFFLINE FALLBACK ---
  Future<bool> signIn({required String email, required String password}) async {
    final cleanEmail = email.trim();
    final cleanPass = password.trim();

    try {
      // Try online login first
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: cleanPass,
      );

      if (credential.user != null) {
        final prefs = await SharedPreferences.getInstance();

        // CRITICAL: Update local data on every successful online login.
        // This handles cases where the user reset their password through your new screens.
        await prefs.setString(_keyEmail, cleanEmail);
        await prefs.setString(_keyPass, cleanPass);
        await prefs.setString('last_logged_email', cleanEmail);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      // Trigger offline mode if there is no internet
      if (e.code == 'network-request-failed') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.reload(); // Refresh the storage from the device disk

        String? storedEmail = prefs.getString(_keyEmail);
        String? storedPass = prefs.getString(_keyPass);

        // Compare input with locally saved data
        if (storedEmail != null && storedPass != null) {
          if (cleanEmail == storedEmail && cleanPass == storedPass) {
            return true; // Offline login success
          }
        }
        throw "Offline error: Credentials do not match saved data.";
      }
      rethrow;
    }
  }

  // --- PASSWORD RESET (OFFICIAL FIREBASE METHOD) ---
  Future<void> sendPasswordReset(String email) async {
    try {
      // Sends a secure reset link to the user's email inbox
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      // Provides a more descriptive error if the email doesn't exist in Firebase Auth
      rethrow;
    }
  }

  // --- SIGN OUT ---
  Future<void> signOut() async {
    // Clear the Firebase session so main.dart redirects to Login/Onboarding
    await _auth.signOut();
  }
}
