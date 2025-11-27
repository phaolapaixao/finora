import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

class Transaction extends Equatable {
  final String? id;
  final double amount;
  final String categoryId;
  final TransactionType type;
  final DateTime date;
  final String? note;
  final DateTime createdAt;

  const Transaction({
    this.id,
    required this.amount,
    required this.categoryId,
    required this.type,
    required this.date,
    this.note,
    required this.createdAt,
  });

  Transaction copyWith({
    String? id,
    double? amount,
    String? categoryId,
    TransactionType? type,
    DateTime? date,
    String? note,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    amount,
    categoryId,
    type,
    date,
    note,
    createdAt,
  ];
}
