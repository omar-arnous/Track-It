import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trackit/core/constants/db_constants.dart';

class LocalService {
  static final LocalService instance = LocalService._internal();

  static Database? _database;

  LocalService._internal();
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, kDatabaseName);
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $kAccountsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        type TEXT,
        balance REAL,
        color TEXT,
        currency TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE $kCategoriesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT,
        color TEXT 
      )
    ''');
    await db.execute('''
      CREATE TABLE $kTransactionsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL, 
        amount REAL DEFAULT 0,
        currency TEXT,
        exchange_rate REAL,
        converted_amount REAL,
        note TEXT,
        date TEXT,
        account_id INTEGER NOT NULL,
        category_id INTEGER NOT NULL,
        FOREIGN KEY (account_id) REFERENCES $kAccountsTable (id),
        FOREIGN KEY (category_id) REFERENCES $kCategoriesTable (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE $kBudgetsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount_limit REAL,
        period TEXT,
        start_date TEXT, 
        end_date TEXT ,
        category_id INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES $kCategoriesTable (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE $kRecurringTransactionsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        currency TEXT NOT NULL,
        frequency TEXT,
        next_due_date TEXT,
        created_at TEXT,
        account_id INTEGER NOT NULL,
        category_id INTEGER NOT NULL,
        FOREIGN KEY (account_id) REFERENCES $kAccountsTable (id),
        FOREIGN KEY (category_id) REFERENCES $kCategoriesTable (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE $kExchangeRateTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        base_currency TEXT,
        target_currency TEXT,
        rate REAL,
        last_updated TEXT
      )
    ''');
  }
}
