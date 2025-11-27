import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/database_helper.dart';
import '../models/category_model.dart';
import '../../core/constants/app_constants.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final DatabaseHelper databaseHelper;

  CategoryRepositoryImpl({required this.databaseHelper});

  @override
  Future<String> addCategory(Categoria category) async {
    final db = await databaseHelper.database;
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final model = CategoryModel(
      id: id,
      nome: category.nome,
      icon: category.icon,
      color: category.color,
      order: category.order,
      type: category.type,
    );

    await db.insert(AppConstants.tabelaCategorias, model.toJson());

    return id;
  }

  @override
  Future<void> deleteCategory(String id) async {
    final db = await databaseHelper.database;
    await db.delete(
      AppConstants.tabelaCategorias,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Categoria>> getCategories() async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.tabelaCategorias,
      orderBy: 'order_index ASC',
    );

    print('DEBUG REPOSITORY: Total de categorias no banco: ${maps.length}');
    for (var map in maps) {
      print(
        'DEBUG REPOSITORY: Categoria "${map['name']}" - type: "${map['type']}"',
      );
    }

    return maps.map((map) => CategoryModel.fromJson(map).toEntity()).toList();
  }

  @override
  Future<Categoria?> getCategoryById(String id) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.tabelaCategorias,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return CategoryModel.fromJson(maps.first).toEntity();
  }

  @override
  Future<void> reorderCategories(List<Categoria> categories) async {
    final db = await databaseHelper.database;

    await db.transaction((txn) async {
      for (var i = 0; i < categories.length; i++) {
        final category = categories[i];
        final model = CategoryModel.fromEntity(category.copyWith(order: i));

        await txn.update(
          AppConstants.tabelaCategorias,
          model.toJson(),
          where: 'id = ?',
          whereArgs: [category.id],
        );
      }
    });
  }

  @override
  Future<void> updateCategory(Categoria category) async {
    final db = await databaseHelper.database;
    final model = CategoryModel.fromEntity(category);

    await db.update(
      AppConstants.tabelaCategorias,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }
}
