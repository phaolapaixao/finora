import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Categoria extends Equatable {
  final String? id;
  final String nome;
  final IconData icon;
  final Color color;
  final int order;
  final String type;

  const Categoria({
    this.id,
    required this.nome,
    required this.icon,
    required this.color,
    this.order = 0,
    this.type = 'expense',
  });

  Categoria copyWith({
    String? id,
    String? nome,
    IconData? icon,
    Color? color,
    int? order,
    String? type,
  }) {
    return Categoria(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      order: order ?? this.order,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [id, nome, icon, color, order, type];
}
