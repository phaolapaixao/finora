import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';

class CategoryModel extends Categoria {
  const CategoryModel({
    super.id,
    required super.nome,
    required super.icon,
    required super.color,
    super.order,
    super.type,
  });

  factory CategoryModel.fromEntity(Categoria category) {
    return CategoryModel(
      id: category.id,
      nome: category.nome,
      icon: category.icon,
      color: category.color,
      order: category.order,
      type: category.type,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String?,
      nome: json['nome'] as String,
      icon: IconData(
        json['icon_code_point'] as int,
        fontFamily: json['icon_font_family'] as String,
      ),
      color: Color(json['color_value'] as int),
      order: json['order_index'] as int? ?? 0,
      type: json['type'] as String? ?? 'expense',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nome,
      'icon_code_point': icon.codePoint,
      'icon_font_family': icon.fontFamily ?? 'MaterialIcons',
      'color_value': color.value,
      'order_index': order,
      'type': type,
    };
  }

  Categoria toEntity() {
    return Categoria(
      id: id,
      nome: nome,
      icon: icon,
      color: color,
      order: order,
      type: type,
    );
  }
}
