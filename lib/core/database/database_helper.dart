import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('aqark.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4, // Version 4 adds 'favorites' column to users table
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Drop and recreate table for development to ensure 'type' column exists
      await db.execute('DROP TABLE IF EXISTS favorites');
      await _createFavoritesTable(db);
    }
    
    if (oldVersion < 4) {
      // Add favorites column to users table for property ID persistence
      await db.execute('ALTER TABLE users ADD COLUMN favorites TEXT');
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
        type TEXT,
        userid TEXT
      )
    ''');
  }

  // --- Favorites CRUD ---
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
      final Map<String, dynamic> user = Map.from(maps.first);
      
      // Parse JSON favorites back to List
      if (user['favorites'] != null && user['favorites'] is String) {
        try {
          user['favorites'] = jsonDecode(user['favorites'] as String);
        } catch (_) {
          user['favorites'] = [];
        }
      } else {
        user['favorites'] = [];
      }
      
      return user;
    }
    return null;
  }

  Future<void> clearDatabase() async {
    final db = await instance.database;
    await db.delete('users');
    await db.delete('sync_queue');
    await db.delete('favorites');
    await db.delete('settings');
  }
}
