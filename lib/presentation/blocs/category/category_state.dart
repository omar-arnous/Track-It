part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitialState extends CategoryState {}

class LoadingCategoriesState extends CategoryState {}

class LoadedCategoriesState extends CategoryState {
  final List<Category> categories;

  const LoadedCategoriesState({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class ErrorCategoryState extends CategoryState {
  final String message;

  const ErrorCategoryState({required this.message});

  @override
  List<Object?> get props => [message];
}
