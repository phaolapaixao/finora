import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/category_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc({required this.repository}) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<ReorderCategories>(_onReorderCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final categories = await repository.getCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Erro ao carregar categorias: ${e.toString()}'));
    }
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await repository.addCategory(event.category);
      emit(const CategoryOperationSuccess('Categoria adicionada com sucesso!'));
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError('Erro ao adicionar categoria: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await repository.updateCategory(event.category);
      emit(const CategoryOperationSuccess('Categoria atualizada com sucesso!'));
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError('Erro ao atualizar categoria: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await repository.deleteCategory(event.id);
      emit(const CategoryOperationSuccess('Categoria excluída com sucesso!'));
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError('Erro ao excluir categoria: ${e.toString()}'));
    }
  }

  Future<void> _onReorderCategories(
    ReorderCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await repository.reorderCategories(event.categories);
      emit(
        const CategoryOperationSuccess('Categorias reordenadas com sucesso!'),
      );
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError('Erro ao reordenar categorias: ${e.toString()}'));
    }
  }
}
