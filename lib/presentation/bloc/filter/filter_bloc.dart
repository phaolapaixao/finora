import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterState.initial()) {
    on<SetDateRange>(_onSetDateRange);
    on<SetCategory>(_onSetCategory);
    on<SetTransactionType>(_onSetTransactionType);
    on<ClearFilters>(_onClearFilters);
    on<ClearDateRange>(_onClearDateRange);
    on<ClearCategory>(_onClearCategory);
    on<ClearType>(_onClearType);
  }

  void _onSetDateRange(SetDateRange event, Emitter<FilterState> emit) {
    emit(
      state.copyWith(
        startDate: event.startDate,
        endDate: event.endDate,
        isActive: true,
      ),
    );
  }

  void _onSetCategory(SetCategory event, Emitter<FilterState> emit) {
    emit(state.copyWith(categoryId: event.categoryId, isActive: true));
  }

  void _onSetTransactionType(
    SetTransactionType event,
    Emitter<FilterState> emit,
  ) {
    emit(state.copyWith(type: event.type, isActive: true));
  }

  void _onClearFilters(ClearFilters event, Emitter<FilterState> emit) {
    emit(FilterState.initial());
  }

  void _onClearDateRange(ClearDateRange event, Emitter<FilterState> emit) {
    emit(state.copyWith(clearStartDate: true, clearEndDate: true));
    _checkIfFiltersActive(emit);
  }

  void _onClearCategory(ClearCategory event, Emitter<FilterState> emit) {
    emit(state.copyWith(clearCategoryId: true));
    _checkIfFiltersActive(emit);
  }

  void _onClearType(ClearType event, Emitter<FilterState> emit) {
    emit(state.copyWith(clearType: true));
    _checkIfFiltersActive(emit);
  }

  void _checkIfFiltersActive(Emitter<FilterState> emit) {
    final hasActiveFilters =
        state.startDate != null ||
        state.endDate != null ||
        state.categoryId != null ||
        state.type != null;

    if (state.isActive != hasActiveFilters) {
      emit(state.copyWith(isActive: hasActiveFilters));
    }
  }
}
