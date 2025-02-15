import 'package:dartz/dartz.dart';
import 'package:trackit/domain/entities/category.dart';
import 'package:trackit/domain/repositories/category_repository.dart';

class AddCategoryUsecase {
  final CategoryRepository repository;

  AddCategoryUsecase({required this.repository});

  Future<Unit> call(Category category) async {
    return await repository.addCategory(category);
  }
}
