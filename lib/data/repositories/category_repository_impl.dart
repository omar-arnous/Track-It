import 'package:dartz/dartz.dart';
import 'package:trackit/core/errors/exceptions.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/data/datasources/category/category_local_datasource.dart';
import 'package:trackit/data/models/category_model.dart';
import 'package:trackit/domain/entities/category.dart';
import 'package:trackit/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDatasource localDatasource;

  CategoryRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, Unit>> addCategory(List<Category> categories) async {
    try {
      List<CategoryModel> categoriesData = categories
          .map((category) => CategoryModel(
              name: category.name, icon: category.icon, color: category.color))
          .toList();
      await localDatasource.addCategory(categoriesData);
      return const Right(unit);
    } on OfflineDatabaseException {
      return Left(OfflineDatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await localDatasource.getCategories();
      return Right(categories);
    } on EmptyDatabaseException {
      return Left(EmptyDatabaseFailure());
    }
  }
}
