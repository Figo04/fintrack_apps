import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fintrack.db');

    return await openDatabase(
      path,
      version: 2, // Increased version for updates
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Tabel account_types
    await db.execute('''
      CREATE TABLE account_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        icon TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Tabel user_accounts dengan tambahan account_name
    await db.execute('''
      CREATE TABLE user_accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        account_type_id INTEGER NOT NULL,
        account_name TEXT,
        balance REAL NOT NULL DEFAULT 0.0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (account_type_id) REFERENCES account_types (id)
      )
    ''');

    // Tabel transactions
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        account_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (account_id) REFERENCES user_accounts (id)
      )
    ''');

    // Insert default account types sesuai dengan UI
    final now = DateTime.now().toIso8601String();

    // Baris pertama
    await db.insert('account_types', {
      'name': 'Uang Tunai',
      'icon': 'money',
      'created_at': now,
    });
    await db.insert('account_types', {
      'name': 'BCA',
      'icon': 'account_balance',
      'created_at': now,
    });
    await db.insert('account_types', {
      'name': 'BRI',
      'icon': 'account_balance',
      'created_at': now,
    });

    // Baris kedua
    await db.insert('account_types', {
      'name': 'Dana',
      'icon': 'account_balance_wallet',
      'created_at': now,
    });
    await db.insert('account_types', {
      'name': 'Gopay',
      'icon': 'account_balance_wallet_outlined',
      'created_at': now,
    });
    await db.insert('account_types', {
      'name': 'Jago',
      'icon': 'account_balance',
      'created_at': now,
    });

    // Baris ketiga
    await db.insert('account_types', {
      'name': 'Jenius',
      'icon': 'account_balance',
      'created_at': now,
    });
    await db.insert('account_types', {
      'name': 'Mandiri',
      'icon': 'account_balance',
      'created_at': now,
    });
    await db.insert('account_types', {
      'name': 'OVO',
      'icon': 'account_balance_wallet',
      'created_at': now,
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add account_name column if upgrading from version 1
      try {
        await db
            .execute('ALTER TABLE user_accounts ADD COLUMN account_name TEXT');
      } catch (e) {
        print('Column account_name might already exist: $e');
      }

      // Update account types to match new UI
      await db.delete('account_types');

      final now = DateTime.now().toIso8601String();

      // Insert updated account types
      await db.insert('account_types', {
        'name': 'Uang Tunai',
        'icon': 'money',
        'created_at': now,
      });
      await db.insert('account_types', {
        'name': 'BCA',
        'icon': 'account_balance',
        'created_at': now,
      });
      await db.insert('account_types', {
        'name': 'BRI',
        'icon': 'account_balance',
        'created_at': now,
      });
      await db.insert('account_types', {
        'name': 'Dana',
        'icon': 'account_balance_wallet',
        'created_at': now,
      });
      await db.insert('account_types', {
        'name': 'Gopay',
        'icon': 'account_balance_wallet_outlined',
        'created_at': now,
      });
      await db.insert('account_types', {
        'name': 'Jago',
        'icon': 'account_balance',
        'created_at': now,
      });
      await db.insert('account_types', {
        'name': 'Jenius',
        'icon': 'account_balance',
        'created_at': now,
      });
      await db.insert('account_types', {
        'name': 'Mandiri',
        'icon': 'account_balance',
        'created_at': now,
      });
      await db.insert('account_types', {
        'name': 'OVO',
        'icon': 'account_balance_wallet',
        'created_at': now,
      });
    }
  }

  // Method untuk reset database (development only)
  Future<void> resetDatabase() async {
    String path = join(await getDatabasesPath(), 'fintrack.db');
    await deleteDatabase(path);
    _database = null;
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
