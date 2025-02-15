import 'package:dartz/dartz.dart';
import 'package:trackit/domain/entities/category.dart';
import 'package:trackit/domain/repositories/category_repository.dart';

class AddCategoryUsecase {
  final CategoryRepository repository;

  AddCategoryUsecase({required this.repository});

  Future<Unit> call(List<Category> categories) async {
    return await repository.addCategory(categories);
  }
}
