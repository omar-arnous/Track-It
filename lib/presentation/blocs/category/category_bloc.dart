import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/core/strings/failures.dart';
import 'package:trackit/domain/entities/category.dart';
import 'package:trackit/domain/usecases/category/add_category.dart';
import 'package:trackit/domain/usecases/category/get_categories.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final AddCategoryUsecase addCategories;
  final GetCategoriesUsecase getCategories;

  CategoryBloc({
    required this.addCategories,
    required this.getCategories,
  }) : super(CategoryInitialState()) {
    on<CategoryEvent>((event, emit) async {
      if (event is AddCategoryEvent) {
        emit(LoadingCategoriesState());
        final res = await addCategories(
          event.categories,
        );

        emit(_mapResponseToUnit(res, event.categories));
      } else if (event is GetCategoriesEvent) {
        emit(LoadingCategoriesState());

        final res = await getCategories();
        emit(_mapResponseToState(res));
      }
    });
  }

  CategoryState _mapResponseToState(Either<Failure, List<Category>> res) {
    return res.fold(
      (failure) => ErrorCategoryState(message: _getMessage(failure)),
      (categories) => LoadedCategoriesState(categories: categories),
    );
  }

  CategoryState _mapResponseToUnit(
      Either<Failure, Unit> res, List<Category> categories) {
    return res.fold(
        (failure) => ErrorCategoryState(message: _getMessage(failure)),
        (_) => LoadedCategoriesState(categories: categories));
  }

  String _getMessage(Failure failure) {
    return kGenericFailureMessage;
  }
}
