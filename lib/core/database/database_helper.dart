import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static Future<Database>? _databaseFuture;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    // Prevent multiple concurrent initializations
    _databaseFuture ??= _initDB('aqark.db');
    _database = await _databaseFuture;
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 7, // Incremented for composite PK in favorites
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('DROP TABLE IF EXISTS favorites');
      await _createFavoritesTable(db);
    }
    
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE users ADD COLUMN favorites TEXT');
    }

    if (oldVersion < 5) {
      await _createPropertiesTable(db);
    }

    if (oldVersion < 6) {
      try {
        await db.execute('ALTER TABLE favorites ADD COLUMN syncStatus TEXT DEFAULT "synced"');
      } catch (e) {
        debugPrint("Error adding syncStatus: $e");
      }
    }

    if (oldVersion < 7) {
      // Migrate favorites table to composite primary key (id, userid)
      // This allows multiple users on the same device to have their own favorites.
      await db.execute('ALTER TABLE favorites RENAME TO favorites_old');
      await _createFavoritesTable(db);
      try {
        await db.execute('''
          INSERT INTO favorites (id, userid, title, description, price, address, imageUrl, ownerId, timestamp, beds, baths, sqm, type, syncStatus)
          SELECT id, userid, title, description, price, address, imageUrl, ownerId, timestamp, beds, baths, sqm, type, syncStatus FROM favorites_old
        ''');
      } catch (e) {
        debugPrint("Error migrating favorites data: $e");
      }
      await db.execute('DROP TABLE IF EXISTS favorites_old');
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        name TEXT,
        phone TEXT,
        photo_url TEXT,
        favorites TEXT,
        last_updated INTEGER
      )
    ''');

    await _createFavoritesTable(db);
    await _createPropertiesTable(db);

    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action TEXT NOT NULL,
        payload TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');
  }

  Future _createFavoritesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS favorites (
        id TEXT,
        userid TEXT,
        title TEXT,
        description TEXT,
        price REAL,
        address TEXT,
        imageUrl TEXT,
        ownerId TEXT,
        timestamp INTEGER,
        beds INTEGER,
        baths INTEGER,
        sqm INTEGER,
        type TEXT,
        syncStatus TEXT DEFAULT 'synced',
        PRIMARY KEY (id, userid)
      )
    ''');
  }

  Future _createPropertiesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS properties (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        price REAL,
        address TEXT,
        imageUrl TEXT,
        ownerId TEXT,
        timestamp INTEGER,
        beds INTEGER,
        baths INTEGER,
        sqm INTEGER,
        type TEXT
      )
    ''');
  }

  // --- Properties CRUD ---
  Future<void> saveProperties(List<Map<String, dynamic>> properties) async {
    final db = await instance.database;
    final batch = db.batch();
    for (var prop in properties) {
      batch.insert(
        'properties',
        prop,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getProperties() async {
    final db = await instance.database;
    return await db.query('properties', orderBy: 'timestamp DESC');
  }

  Future<void> syncFavoritesToLocal(List<Map<String, dynamic>> favorites, String userId) async {
    final db = await instance.database;
    final batch = db.batch();
    
    for (var fav in favorites) {
      batch.insert(
        'favorites',
        {...fav, 'userid': userId, 'syncStatus': 'synced'},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
  Future<void> saveFavorite(Map<String, dynamic> propertyMap) async {
    final db = await instance.database;
    await db.insert(
      'favorites',
      propertyMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String propertyId, String userId) async {
    final db = await instance.database;
    await db.delete(
      'favorites',
      where: 'id = ? AND userid = ?',
      whereArgs: [propertyId, userId],
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    final db = await instance.database;
    return await db.query(
      'favorites',
      where: 'userid = ?',
      whereArgs: [userId],
    );
  }

  Future<bool> isFavorite(String propertyId, String userId) async {
    final db = await instance.database;
    final maps = await db.query(
      'favorites',
      where: 'id = ? AND userid = ?',
      whereArgs: [propertyId, userId],
    );
    return maps.isNotEmpty;
  }

  // --- Settings CRUD ---
  Future<void> saveSetting(String key, String value) async {
    final db = await instance.database;
    await db.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await instance.database;
    final maps = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isNotEmpty) {
      return maps.first['value'] as String?;
    }
    return null;
  }

  // --- User CRUD ---
  Future<void> saveUser(Map<String, dynamic> userData) async {
    final db = await instance.database;
    
    // Create a copy to avoid mutating the original map
    final Map<String, dynamic> data = Map.from(userData);
    
    // Handle favorites list conversion to JSON string
    if (data['favorites'] != null && data['favorites'] is List) {
      data['favorites'] = jsonEncode(data['favorites']);
    }

    await db.insert(
      'users',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [uid],
    );
    
    if (maps.isNotEmpty) {
      return _parseUserMap(maps.first);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return _parseUserMap(maps.first);
    }
    return null;
  }

  Map<String, dynamic> _parseUserMap(Map<String, dynamic> map) {
    final Map<String, dynamic> user = Map.from(map);
    // Parse JSON favorites back to List
    if (user['favorites'] != null && user['favorites'] is String) {
      try {
        user['favorites'] = jsonDecode(user['favorites'] as String);
      } catch (_) {
        user['favorites'] = [];
      }
    } else if (user['favorites'] == null) {
      user['favorites'] = [];
    }
    return user;
  }

  // --- Sync Status Queries ---
  Future<List<Map<String, dynamic>>> getPendingSyncFavorites(String userId) async {
    final db = await instance.database;
    return await db.query(
      'favorites',
      where: 'userid = ? AND syncStatus != ?',
      whereArgs: [userId, 'synced'],
    );
  }

  Future<void> clearSyncedFavorites(String userId, List<String> remoteIds) async {
    final db = await instance.database;
    // Remove local favorites that are marked as 'synced' but are not in the remote list
    // This ensures that favorites removed on other devices are removed locally too.
    if (remoteIds.isEmpty) {
      await db.delete(
        'favorites',
        where: 'userid = ? AND syncStatus = ?',
        whereArgs: [userId, 'synced'],
      );
    } else {
      final placeholders = List.filled(remoteIds.length, '?').join(',');
      await db.delete(
        'favorites',
        where: 'userid = ? AND syncStatus = ? AND id NOT IN ($placeholders)',
        whereArgs: [userId, 'synced', ...remoteIds],
      );
    }
  }

  // --- Sync Queue ---
  Future<void> addToSyncQueue(String action, Map<String, dynamic> payload) async {
    final db = await instance.database;
    await db.insert('sync_queue', {
      'action': action,
      'payload': jsonEncode(payload),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, dynamic>>> getSyncQueue() async {
    final db = await instance.database;
    return await db.query('sync_queue', orderBy: 'timestamp ASC');
  }

  Future<void> removeFromSyncQueue(int id) async {
    final db = await instance.database;
    await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }
}
