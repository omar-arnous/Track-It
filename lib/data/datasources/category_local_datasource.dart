import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trackit/config/local_service.dart';
import 'package:trackit/core/constants/db_constants.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/data/models/category_model.dart';

abstract class CategoryLocalDatasource {
  Future<List<CategoryModel>> getCategories();
  Future<Unit> addCategory(List<CategoryModel> categories);
}

class CategoryLocalDatasourceImpl implements CategoryLocalDatasource {
  LocalService dbService;
  CategoryLocalDatasourceImpl({required this.dbService});

  @override
  Future<Unit> addCategory(List<CategoryModel> categories) async {
    final db = await dbService.database;
    categories.map((category) async {
      final data = category.toJson();
      await db.insert(kCategoriesTable, data);
    });

    return Future.value(unit);
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final db = await dbService.database;
    final data = await db.query(kCategoriesTable);
    if (data.isNotEmpty) {
      final List<CategoryModel> categories = data
          .map<CategoryModel>((category) => CategoryModel.fromJson(category))
          .toList();

      return categories;
    } else {
      throw EmptyDatabaseException();
    }
  }
}
