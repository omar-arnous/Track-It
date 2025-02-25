import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trackit/core/constants/db_constants.dart';
import 'package:trackit/data/models/category_model.dart';

List<CategoryModel> defaultCategories = [
  const CategoryModel(
    id: 1,
    name: 'Food & Drinks',
    icon: Icons.restaurant_menu,
    color: Colors.red,
  ),
  const CategoryModel(
    id: 2,
    name: 'Vehicle Service',
    icon: Icons.car_crash,
    color: Colors.red,
  ),
  const CategoryModel(
    id: 3,
    name: 'Health, Beauty',
    icon: Icons.brush,
    color: Colors.pink,
  ),
  const CategoryModel(
    id: 4,
    name: 'HealthCare, Doctor',
    icon: Icons.healing,
    color: Colors.green,
  ),
  const CategoryModel(
    id: 5,
    name: 'Bills',
    icon: Icons.receipt,
    color: Colors.green,
  ),
  const CategoryModel(
    id: 6,
    name: 'Financial Expenses',
    icon: Icons.payment,
    color: Colors.green,
  ),
  const CategoryModel(
    id: 7,
    name: 'Electrical devices',
    icon: Icons.electric_bolt,
    color: Colors.orange,
  ),
  const CategoryModel(
    id: 8,
    name: 'Communication, PC',
    icon: Icons.phone,
    color: Colors.orange,
  ),
  const CategoryModel(
    id: 9,
    name: 'Housing',
    icon: Icons.house,
    color: Colors.orange,
  ),
  const CategoryModel(
    id: 10,
    name: 'Investments',
    icon: Icons.line_axis,
    color: Colors.yellow,
  ),
  const CategoryModel(
    id: 11,
    name: 'Salary',
    icon: Icons.attach_money,
    color: Colors.yellow,
  ),
  const CategoryModel(
    id: 12,
    name: 'Fees',
    icon: Icons.account_balance,
    color: Colors.yellow,
  ),
  const CategoryModel(
    id: 13,
    name: 'Enteirtainment',
    icon: Icons.movie,
    color: Colors.blue,
  ),
  const CategoryModel(
    id: 14,
    name: 'Travel',
    icon: Icons.beach_access,
    color: Colors.blue,
  ),
  const CategoryModel(
    id: 15,
    name: 'Shopping',
    icon: Icons.shopping_bag,
    color: Colors.blue,
  ),
  const CategoryModel(
    id: 16,
    name: 'Transport',
    icon: Icons.bus_alert,
    color: Colors.grey,
  ),
  const CategoryModel(
    id: 17,
    name: 'Charity, Gift',
    icon: Icons.card_giftcard,
    color: Colors.grey,
  ),
  const CategoryModel(
    id: 18,
    name: 'Other',
    icon: Icons.menu,
    color: Colors.grey,
  ),
];

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
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        icon TEXT,
        color TEXT 
      )
    ''');
    await db.execute('''
      CREATE TABLE $kTransactionsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL, 
        payment_type TEXT NOT NULL,
        amount REAL DEFAULT 0,
        currency TEXT,
        exchange_rate REAL default 0,
        converted_amount REAL default 0,
        note TEXT,
        date TEXT,
        time TEXT,
        account_id INTEGER NOT NULL,
        target_account_id INTEGER NOT NULL,
        category_id INTEGER NOT NULL,
        FOREIGN KEY (account_id) REFERENCES $kAccountsTable (id),
        FOREIGN KEY (target_account_id) REFERENCES $kAccountsTable (id),
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

    await insertDefaultCategories(db);
  }

  Future<void> insertDefaultCategories(Database db) async {
    List<Map<String, dynamic>> categoryData = defaultCategories.map((category) {
      return category.toJson();
    }).toList();

    for (var category in categoryData) {
      await db.insert(
        kCategoriesTable,
        category,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }
}
