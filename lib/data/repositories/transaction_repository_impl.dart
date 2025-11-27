import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/database_helper.dart';
import '../models/transaction_model.dart';
import '../../core/constants/app_constants.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final DatabaseHelper databaseHelper;

  TransactionRepositoryImpl({required this.databaseHelper});

  @override
  Future<String> addTransaction(Transaction transaction) async {
    final db = await databaseHelper.database;
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final model = TransactionModel(
      id: id,
      amount: transaction.amount,
      categoryId: transaction.categoryId,
      type: transaction.type,
      date: transaction.date,
      note: transaction.note,
      createdAt: transaction.createdAt,
    );

    await db.insert(AppConstants.tabelaTrasacoes, model.toJson());

    return id;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final db = await databaseHelper.database;
    await db.delete(
      AppConstants.tabelaTrasacoes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<Transaction?> getTransactionById(String id) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.tabelaTrasacoes,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return TransactionModel.fromJson(maps.first).toEntity();
  }

  @override
  Future<List<Transaction>> getTransactions() async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.tabelaTrasacoes,
      orderBy: 'date DESC',
    );

    return maps
        .map((map) => TransactionModel.fromJson(map).toEntity())
        .toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByCategory(String categoryId) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.tabelaTrasacoes,
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'date DESC',
    );

    return maps
        .map((map) => TransactionModel.fromJson(map).toEntity())
        .toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.tabelaTrasacoes,
      where: 'date BETWEEN ? AND ?',
      whereArgs: [
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      ],
      orderBy: 'date DESC',
    );

    return maps
        .map((map) => TransactionModel.fromJson(map).toEntity())
        .toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByType(TransactionType type) async {
    final db = await databaseHelper.database;
    final typeString = type == TransactionType.income ? 'income' : 'expense';

    final maps = await db.query(
      AppConstants.tabelaTrasacoes,
      where: 'type = ?',
      whereArgs: [typeString],
      orderBy: 'date DESC',
    );

    return maps
        .map((map) => TransactionModel.fromJson(map).toEntity())
        .toList();
  }

  @override
  Future<Map<String, double>> getTotalByCategory(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await databaseHelper.database;
    final result = await db.rawQuery(
      '''
      SELECT category_id, SUM(amount) as total
      FROM ${AppConstants.tabelaTrasacoes}
      WHERE date BETWEEN ? AND ?
      GROUP BY category_id
    ''',
      [startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch],
    );

    final Map<String, double> totals = {};
    for (final row in result) {
      totals[row['category_id'] as String] = (row['total'] as num).toDouble();
    }

    return totals;
  }

  @override
  Future<double> getTotalByType(TransactionType type) async {
    final db = await databaseHelper.database;
    final typeString = type == TransactionType.income ? 'income' : 'expense';

    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) as total
      FROM ${AppConstants.tabelaTrasacoes}
      WHERE type = ?
    ''',
      [typeString],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<double> getTotalByTypeAndDateRange(
    TransactionType type,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await databaseHelper.database;
    final typeString = type == TransactionType.income ? 'income' : 'expense';

    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) as total
      FROM ${AppConstants.tabelaTrasacoes}
      WHERE type = ? AND date BETWEEN ? AND ?
    ''',
      [
        typeString,
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      ],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final db = await databaseHelper.database;
    final model = TransactionModel.fromEntity(transaction);

    await db.update(
      AppConstants.tabelaTrasacoes,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }
}
