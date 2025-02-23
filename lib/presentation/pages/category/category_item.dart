import 'package:flutter/material.dart';
import 'package:trackit/domain/entities/category.dart';

class CategoryItem extends StatelessWidget {
  final Category categoryItem;
  const CategoryItem({super.key, required this.categoryItem});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(5),
      leading: CircleAvatar(
        child: Icon(
          categoryItem.icon,
          color: categoryItem.color,
        ),
      ),
      title: Text(
        categoryItem.name,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
