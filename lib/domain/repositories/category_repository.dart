import '../entities/category.dart';

abstract class CategoryRepository {
  Future<List<Categoria>> getCategories();

  Future<Categoria?> getCategoryById(String id);

  Future<String> addCategory(Categoria category);
  Future<void> updateCategory(Categoria category);

  Future<void> deleteCategory(String id);

  Future<void> reorderCategories(List<Categoria> categories);
}
