import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackit/presentation/blocs/category/category_bloc.dart';
import 'package:trackit/presentation/pages/category/category_item.dart';
import 'package:trackit/presentation/widgets/spinner.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is LoadingCategoriesState) {
          return const Spinner();
        } else if (state is LoadedCategoriesState) {
          final categories = state.categories;
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return CategoryItem(categoryItem: categories[index]);
            },
            separatorBuilder: (context, index) {
              return const Divider(thickness: 1);
            },
          );
        } else if (state is ErrorCategoryState) {
          return AlertDialog.adaptive(
            title: const Text('Error'),
            content: Text(state.message),
          );
        } else {
          return Center(
            child: Text(
              'No Categories',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
      },
    );
    // return SafeArea(
    //   child: Scaffold(
    //     body: Container(
    //       margin: const EdgeInsets.all(16),
    //       child: BlocBuilder<CategoryBloc, CategoryState>(
    //         builder: (context, state) {
    //           if (state is LoadingCategoriesState) {
    //             return const Spinner();
    //           } else if (state is LoadedCategoriesState) {
    //             final categories = state.categories;
    //             return ListView.separated(
    //               itemCount: categories.length,
    //               itemBuilder: (context, index) {
    //                 return CategoryItem(categoryItem: categories[index]);
    //               },
    //               separatorBuilder: (context, index) {
    //                 return const Divider(thickness: 1);
    //               },
    //             );
    //           } else if (state is ErrorCategoryState) {
    //             return AlertDialog.adaptive(
    //               title: const Text('Error'),
    //               content: Text(state.message),
    //             );
    //           } else {
    //             return Center(
    //               child: Text(
    //                 'No Categories',
    //                 style: Theme.of(context).textTheme.bodyLarge,
    //               ),
    //             );
    //           }
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }
}
