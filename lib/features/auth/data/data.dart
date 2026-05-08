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

  User? get currentUser => _auth.currentUser;

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
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: cleanEmail,
          password: cleanPass,
        );

        final String uid = credential.user!.uid;

        final userData = {
          'id': uid,
          'email': cleanEmail,
          'name': name ?? cleanEmail.split('@')[0],
          'photo_url': credential.user?.photoURL,
          'last_updated': DateTime.now().millisecondsSinceEpoch,
        };
        await _dbHelper.saveUser(userData);
        await _dbRef.child(uid).set(userData);
        await _saveSession(cleanEmail, cleanPass);

        return credential;
      } else {
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
    } catch (e) {
      rethrow;
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
            // If doesn't exist in remote but exists in auth, create entry
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
    if (_auth.currentUser != null) {
      final uid = _auth.currentUser!.uid;
      // Try local first
      final localData = await _dbHelper.getUser(uid);
      if (localData != null) return localData;

      // Try remote if online
      if (await _networkInfo.isConnected) {
        final snapshot = await _dbRef.child(uid).get();
        if (snapshot.exists) {
          final data = Map<String, dynamic>.from(snapshot.value as Map);
          await _dbHelper.saveUser(data);
          return data;
        }
      }
    } else {
      // Offline fallback: find by email
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(_keyEmail);
      if (email != null) {
         final db = await DatabaseHelper.instance.database;
         final maps = await db.query('users', where: 'email = ?', whereArgs: [email]);
         if (maps.isNotEmpty) return maps.first;
      }
    }
    return null;
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
