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
    id: 1,
    name: 'Food & Drinks',
    icon: Icons.restaurant_menu,
    color: Colors.red,
  ),
  const Category(
    id: 2,
    name: 'Vehicle Service',
    icon: Icons.car_crash,
    color: Colors.red,
  ),
  const Category(
    id: 3,
    name: 'Health, Beauty',
    icon: Icons.brush,
    color: Colors.pink,
  ),
  const Category(
    id: 4,
    name: 'HealthCare, Doctor',
    icon: Icons.healing,
    color: Colors.green,
  ),
  const Category(
    id: 5,
    name: 'Bills',
    icon: Icons.receipt,
    color: Colors.green,
  ),
  const Category(
    id: 6,
    name: 'Financial Expenses',
    icon: Icons.payment,
    color: Colors.green,
  ),
  const Category(
    id: 7,
    name: 'Electrical devices',
    icon: Icons.electric_bolt,
    color: Colors.orange,
  ),
  const Category(
    id: 8,
    name: 'Communication, PC',
    icon: Icons.phone,
    color: Colors.orange,
  ),
  const Category(
    id: 9,
    name: 'Housing',
    icon: Icons.house,
    color: Colors.orange,
  ),
  const Category(
    id: 10,
    name: 'Investments',
    icon: Icons.line_axis,
    color: Colors.yellow,
  ),
  const Category(
    id: 11,
    name: 'Salary',
    icon: Icons.attach_money,
    color: Colors.yellow,
  ),
  const Category(
    id: 12,
    name: 'Fees',
    icon: Icons.account_balance,
    color: Colors.yellow,
  ),
  const Category(
    id: 13,
    name: 'Enteirtainment',
    icon: Icons.movie,
    color: Colors.blue,
  ),
  const Category(
    id: 14,
    name: 'Travel',
    icon: Icons.beach_access,
    color: Colors.blue,
  ),
  const Category(
    id: 15,
    name: 'Shopping',
    icon: Icons.shopping_bag,
    color: Colors.blue,
  ),
  const Category(
    id: 16,
    name: 'Transport',
    icon: Icons.bus_alert,
    color: Colors.grey,
  ),
  const Category(
    id: 17,
    name: 'Charity, Gift',
    icon: Icons.card_giftcard,
    color: Colors.grey,
  ),
  const Category(
    id: 18,
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
