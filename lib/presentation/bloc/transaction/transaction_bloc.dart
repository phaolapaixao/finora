import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/repositories/transaction_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  TransactionBloc({required this.repository}) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<LoadTransactionsByDateRange>(_onLoadTransactionsByDateRange);
    on<LoadTransactionsByCategory>(_onLoadTransactionsByCategory);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final transactions = await repository.getTransactions();
      final totalIncome = await repository.getTotalByType(
        TransactionType.income,
      );
      final totalExpense = await repository.getTotalByType(
        TransactionType.expense,
      );

      emit(
        TransactionLoaded(
          transactions: transactions,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          balance: totalIncome - totalExpense,
        ),
      );
    } catch (e) {
      emit(TransactionError('Erro ao carregar transações: ${e.toString()}'));
    }
  }

  Future<void> _onLoadTransactionsByDateRange(
    LoadTransactionsByDateRange event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final transactions = await repository.getTransactionsByDateRange(
        event.startDate,
        event.endDate,
      );
      final totalIncome = await repository.getTotalByTypeAndDateRange(
        TransactionType.income,
        event.startDate,
        event.endDate,
      );
      final totalExpense = await repository.getTotalByTypeAndDateRange(
        TransactionType.expense,
        event.startDate,
        event.endDate,
      );

      emit(
        TransactionLoaded(
          transactions: transactions,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          balance: totalIncome - totalExpense,
        ),
      );
    } catch (e) {
      emit(TransactionError('Erro ao carregar transações: ${e.toString()}'));
    }
  }

  Future<void> _onLoadTransactionsByCategory(
    LoadTransactionsByCategory event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final transactions = await repository.getTransactionsByCategory(
        event.categoryId,
      );

      double totalIncome = 0;
      double totalExpense = 0;

      for (final transaction in transactions) {
        if (transaction.type == TransactionType.income) {
          totalIncome += transaction.amount;
        } else {
          totalExpense += transaction.amount;
        }
      }

      emit(
        TransactionLoaded(
          transactions: transactions,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          balance: totalIncome - totalExpense,
        ),
      );
    } catch (e) {
      emit(TransactionError('Erro ao carregar transações: ${e.toString()}'));
    }
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await repository.addTransaction(event.transaction);
      emit(
        const TransactionOperationSuccess('Transação adicionada com sucesso!'),
      );
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionError('Erro ao adicionar transação: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await repository.updateTransaction(event.transaction);
      emit(
        const TransactionOperationSuccess('Transação atualizada com sucesso!'),
      );
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionError('Erro ao atualizar transação: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await repository.deleteTransaction(event.id);
      emit(
        const TransactionOperationSuccess('Transação excluída com sucesso!'),
      );
      add(LoadTransactions());
    } catch (e) {
      emit(TransactionError('Erro ao excluir transação: ${e.toString()}'));
    }
  }
}
