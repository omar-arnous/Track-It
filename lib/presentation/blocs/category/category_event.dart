part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class GetCategoriesEvent extends CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final List<Category> categories;
  const AddCategoryEvent({required this.categories});

  @override
  List<Object?> get props => [categories];
}
