import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
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

  User? get currentUser => _auth.currentUser;

  // --- REGISTRATION ---
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    final cleanEmail = email.trim();
    final cleanPass = password.trim();

    if (await _networkInfo.isConnected) {
      try {
        // 1. Firebase Auth
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: cleanEmail,
          password: cleanPass,
        );

        // 2. Send Verification Email
        try {
          await credential.user?.sendEmailVerification();
          debugPrint("Verification email sent to $cleanEmail");
        } catch (e) {
          debugPrint("Error sending verification email during signup: $e");
          // Account is created, but email failed. We allow navigation to OTP screen
          // where they can try to resend.
        }

        final String uid = credential.user!.uid;

        // 3. Local DB (sqflite)
        final userData = {
          'id': uid,
          'email': cleanEmail,
          'name': name ?? cleanEmail.split('@')[0],
          'photo_url': credential.user?.photoURL,
          'last_updated': DateTime.now().millisecondsSinceEpoch,
        };
        await _dbHelper.saveUser(userData);

        // 4. Remote DB (Firebase Realtime)
        await _dbRef.child(uid).set(userData);

        // 5. Session State
        await _saveSession(cleanEmail, cleanPass);

        return credential;
      } catch (e) {
        rethrow;
      }
    } else {
      // --- OFFLINE SIGNUP ---
      final String localId = 'offline_${DateTime.now().millisecondsSinceEpoch}';
      
      final userData = {
        'id': localId,
        'email': cleanEmail,
        'name': name ?? cleanEmail.split('@')[0],
        'last_updated': DateTime.now().millisecondsSinceEpoch,
      };
      
      await _dbHelper.saveUser(userData);
      await _saveSession(cleanEmail, cleanPass);
      
      return null; 
    }
  }

  // --- RESEND VERIFICATION ---
  Future<void> sendVerificationEmail() async {
    if (await _networkInfo.isConnected) {
      final user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        debugPrint("Verification email resent to ${user.email}");
      } else {
        throw "No user found to send verification email.";
      }
    } else {
      throw "No internet connection to send verification email.";
    }
  }

  // --- LOGIN ---
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
          final snapshot = await _dbRef.child(uid).get();
          if (snapshot.exists) {
            final data = Map<String, dynamic>.from(snapshot.value as Map);
            await _dbHelper.saveUser(data);
          } else {
            final userData = {
              'id': uid,
              'email': cleanEmail,
              'name': credential.user?.displayName ?? cleanEmail.split('@')[0],
              'photo_url': credential.user?.photoURL,
              'last_updated': DateTime.now().millisecondsSinceEpoch,
            };
            await _dbHelper.saveUser(userData);
            await _dbRef.child(uid).set(userData);
          }

          await _saveSession(cleanEmail, cleanPass);
          return true;
        }
      } catch (e) {
        rethrow;
      }
    } else {
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

  Future<Map<String, dynamic>?> getUserData() async {
    Map<String, dynamic>? data;

    if (_auth.currentUser != null) {
      final uid = _auth.currentUser!.uid;
      data = await _dbHelper.getUser(uid);

      if ((data == null || data['name'] == null) && await _networkInfo.isConnected) {
        final snapshot = await _dbRef.child(uid).get();
        if (snapshot.exists) {
          data = Map<String, dynamic>.from(snapshot.value as Map);
          await _dbHelper.saveUser(data);
        }
      }
      
      if (data == null || data['name'] == null) {
        final user = _auth.currentUser!;
        data = {
          'id': user.uid,
          'email': user.email,
          'name': user.displayName ?? user.email?.split('@')[0] ?? "User",
          'photo_url': user.photoURL,
        };
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(_keyEmail);
      if (email != null) {
         final db = await DatabaseHelper.instance.database;
         final maps = await db.query('users', where: 'email = ?', whereArgs: [email]);
         if (maps.isNotEmpty) {
           data = Map<String, dynamic>.from(maps.first);
         } else {
           data = {'email': email, 'name': email.split('@')[0]};
         }
      }
    }
    return data;
  }

  Future<void> updateProfile({String? name, String? photoUrl}) async {
    final userData = await getUserData();
    if (userData == null) return;

    final String uid = userData['id'];
    final updatedData = Map<String, dynamic>.from(userData);
    if (name != null) updatedData['name'] = name;
    if (photoUrl != null) updatedData['photo_url'] = photoUrl;
    updatedData['last_updated'] = DateTime.now().millisecondsSinceEpoch;

    await _dbHelper.saveUser(updatedData);

    if (await _networkInfo.isConnected && !uid.startsWith('offline_')) {
      await _dbRef.child(uid).update(updatedData);
      if (name != null) await _auth.currentUser?.updateDisplayName(name);
      if (photoUrl != null) await _auth.currentUser?.updatePhotoURL(photoUrl);
    }
  }

  Future<bool> checkEmailVerified() async {
    User? user = _auth.currentUser;
    if (user == null) return true; // Offline bypass
    await user.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> _saveSession(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPass, password);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> syncOfflineData() async {
    if (await _networkInfo.isConnected && _auth.currentUser != null) {
      final uid = _auth.currentUser!.uid;
      final localUser = await _dbHelper.getUser(uid);
      if (localUser != null) {
        await _dbRef.child(uid).update(localUser);
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}
