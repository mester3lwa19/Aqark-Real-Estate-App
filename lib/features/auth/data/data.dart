import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/network/network_info.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final DatabaseReference _dbRef;
  final DatabaseHelper _dbHelper;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseDatabase database,
    required DatabaseHelper dbHelper,
    required NetworkInfo networkInfo,
  })  : _auth = auth,
        _dbRef = database.ref("users"),
        _dbHelper = dbHelper,
        _networkInfo = networkInfo;

  static const String _keyEmail = 'local_email';
  static const String _keyPass = 'local_password';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // --- REGISTRATION ---
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    final cleanEmail = email.trim();
    final cleanPass = password.trim();

    try {
      if (await _networkInfo.isConnected) {
        // 1. Firebase Auth
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: cleanEmail,
          password: cleanPass,
        );

        final String uid = credential.user!.uid;

        // 2. Local DB (sqflite)
        final userData = {
          'id': uid,
          'email': cleanEmail,
          'name': name,
          'last_updated': DateTime.now().millisecondsSinceEpoch,
        };
        await _dbHelper.saveUser(userData);

        // 3. Remote DB (Firebase Realtime)
        await _dbRef.child(uid).set(userData);

        // 4. Session State
        await _saveSession(cleanEmail, cleanPass);

        return credential;
      } else {
        throw "No internet connection. Please connect to sign up.";
      }
    } catch (e) {
      rethrow;
    }
  }

  // --- LOGIN WITH OFFLINE FALLBACK ---
  Future<bool> signIn({required String email, required String password}) async {
    final cleanEmail = email.trim();
    final cleanPass = password.trim();

    if (await _networkInfo.isConnected) {
      try {
        UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: cleanEmail,
          password: cleanPass,
        );

        if (credential.user != null) {
          final String uid = credential.user!.uid;

          // Sync from Remote to Local
          final snapshot = await _dbRef.child(uid).get();
          if (snapshot.exists) {
            final data = Map<String, dynamic>.from(snapshot.value as Map);
            await _dbHelper.saveUser(data);
          }

          await _saveSession(cleanEmail, cleanPass);
          return true;
        }
      } catch (e) {
        rethrow;
      }
    } else {
      // Offline mode
      final prefs = await SharedPreferences.getInstance();
      final storedEmail = prefs.getString(_keyEmail);
      final storedPass = prefs.getString(_keyPass);

      if (storedEmail == cleanEmail && storedPass == cleanPass) {
        return true;
      }
      throw "Offline: Credentials do not match locally stored data.";
    }
    return false;
  }

  Future<void> _saveSession(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPass, password);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  // --- PASSWORD RESET ---
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      rethrow;
    }
  }

  // --- SYNC MECHANISM ---
  Future<void> syncOfflineData() async {
    if (await _networkInfo.isConnected && _auth.currentUser != null) {
      final uid = _auth.currentUser!.uid;
      final localUser = await _dbHelper.getUser(uid);
      if (localUser != null) {
        await _dbRef.child(uid).update(localUser);
      }
    }
  }

  // --- SIGN OUT ---
  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}