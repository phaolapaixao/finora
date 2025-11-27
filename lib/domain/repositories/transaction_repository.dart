import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions();

  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  Future<List<Transaction>> getTransactionsByCategory(String categoryId);

  Future<List<Transaction>> getTransactionsByType(TransactionType type);

  Future<Transaction?> getTransactionById(String id);

  Future<String> addTransaction(Transaction transaction);

  Future<void> updateTransaction(Transaction transaction);

  Future<void> deleteTransaction(String id);

  Future<double> getTotalByType(TransactionType type);

  Future<double> getTotalByTypeAndDateRange(
    TransactionType type,
    DateTime startDate,
    DateTime endDate,
  );

  Future<Map<String, double>> getTotalByCategory(
    DateTime startDate,
    DateTime endDate,
  );
}
