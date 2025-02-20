import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/core/errors/failures.dart';
import 'package:trackit/core/strings/failures.dart';
import 'package:trackit/domain/entities/category.dart';
import 'package:trackit/domain/usecases/category/add_category.dart';
import 'package:trackit/domain/usecases/category/get_categories.dart';

part 'category_event.dart';
part 'category_state.dart';

List<Category> defaultCategories = [
  const Category(
    name: 'Food & Drinks',
    icon: Icons.restaurant_menu,
    color: Colors.red,
  ),
  const Category(
    name: 'Vehicle Service',
    icon: Icons.car_crash,
    color: Colors.red,
  ),
  const Category(
    name: 'Health, Beauty',
    icon: Icons.brush,
    color: Colors.pink,
  ),
  const Category(
    name: 'HealthCare, Doctor',
    icon: Icons.healing,
    color: Colors.green,
  ),
  const Category(
    name: 'Bills',
    icon: Icons.receipt,
    color: Colors.green,
  ),
  const Category(
    name: 'Financial Expenses',
    icon: Icons.payment,
    color: Colors.green,
  ),
  const Category(
    name: 'Electrical devices',
    icon: Icons.electric_bolt,
    color: Colors.orange,
  ),
  const Category(
    name: 'Communication, PC',
    icon: Icons.phone,
    color: Colors.orange,
  ),
  const Category(
    name: 'Housing',
    icon: Icons.house,
    color: Colors.orange,
  ),
  const Category(
    name: 'Investments',
    icon: Icons.line_axis,
    color: Colors.yellow,
  ),
  const Category(
    name: 'Salary',
    icon: Icons.attach_money,
    color: Colors.yellow,
  ),
  const Category(
    name: 'Fees',
    icon: Icons.account_balance,
    color: Colors.yellow,
  ),
  const Category(
    name: 'Enteirtainment',
    icon: Icons.movie,
    color: Colors.blue,
  ),
  const Category(
    name: 'Travel',
    icon: Icons.beach_access,
    color: Colors.blue,
  ),
  const Category(
    name: 'Shopping',
    icon: Icons.shopping_bag,
    color: Colors.blue,
  ),
  const Category(
    name: 'Transport',
    icon: Icons.bus_alert,
    color: Colors.grey,
  ),
  const Category(
    name: 'Charity, Gift',
    icon: Icons.card_giftcard,
    color: Colors.grey,
  ),
  const Category(
    name: 'Other',
    icon: Icons.menu,
    color: Colors.grey,
  ),
];

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
    switch (failure.runtimeType) {
      case EmptyDatabaseFailure:
        add(AddCategoryEvent(categories: defaultCategories));
        return kEmptyDatabaseFailureMessage;
      default:
        return kGenericFailureMessage;
    }
  }
}
