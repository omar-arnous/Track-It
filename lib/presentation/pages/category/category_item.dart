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
        backgroundColor: categoryItem.color,
        child: Icon(
          categoryItem.icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        categoryItem.name,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
