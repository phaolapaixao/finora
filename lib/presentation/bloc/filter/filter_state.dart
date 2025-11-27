import 'package:equatable/equatable.dart';
import '../../../domain/entities/transaction.dart';

class FilterState extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? categoryId;
  final TransactionType? type;
  final bool isActive;

  const FilterState({
    this.startDate,
    this.endDate,
    this.categoryId,
    this.type,
    this.isActive = false,
  });

  factory FilterState.initial() {
    return const FilterState(
      startDate: null,
      endDate: null,
      categoryId: null,
      type: null,
      isActive: false,
    );
  }

  FilterState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    TransactionType? type,
    bool? isActive,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearCategoryId = false,
    bool clearType = false,
  }) {
    return FilterState(
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      type: clearType ? null : (type ?? this.type),
      isActive: isActive ?? this.isActive,
    );
  }

  FilterState clearFilters() {
    return FilterState.initial();
  }

  @override
  List<Object?> get props => [startDate, endDate, categoryId, type, isActive];
}
