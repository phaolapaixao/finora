import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    super.id,
    required super.amount,
    required super.categoryId,
    required super.type,
    required super.date,
    super.note,
    required super.createdAt,
  });

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      amount: transaction.amount,
      categoryId: transaction.categoryId,
      type: transaction.type,
      date: transaction.date,
      note: transaction.note,
      createdAt: transaction.createdAt,
    );
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['category_id'] as String,
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      note: json['note'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category_id': categoryId,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'date': date.millisecondsSinceEpoch,
      'note': note,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  Transaction toEntity() {
    return Transaction(
      id: id,
      amount: amount,
      categoryId: categoryId,
      type: type,
      date: date,
      note: note,
      createdAt: createdAt,
    );
  }
}
