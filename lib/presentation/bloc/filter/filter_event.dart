import 'package:equatable/equatable.dart';
import '../../../domain/entities/transaction.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class SetDateRange extends FilterEvent {
  final DateTime startDate;
  final DateTime endDate;

  const SetDateRange({required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class SetCategory extends FilterEvent {
  final String categoryId;

  const SetCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class SetTransactionType extends FilterEvent {
  final TransactionType type;

  const SetTransactionType(this.type);

  @override
  List<Object?> get props => [type];
}

class ClearFilters extends FilterEvent {}

class ClearDateRange extends FilterEvent {}

class ClearCategory extends FilterEvent {}

class ClearType extends FilterEvent {}
