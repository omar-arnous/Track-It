import 'package:trackit/core/utils/color_convertor.dart';
import 'package:trackit/core/utils/icon_convertor.dart';
import 'package:trackit/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    super.id,
    required super.name,
    required super.icon,
    required super.color,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: IconConvertor.stringToIconData(json['icon']),
      color: ColorConvertor.hexStringToColor(json['color']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': IconConvertor.iconDataToString(icon),
      'color': ColorConvertor.colorToHexString(color),
    };
  }
}
