import 'package:equatable/equatable.dart';
import '../../../domain/entities/category.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final Categoria category;

  const AddCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class UpdateCategory extends CategoryEvent {
  final Categoria category;

  const UpdateCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class DeleteCategory extends CategoryEvent {
  final String id;

  const DeleteCategory(this.id);

  @override
  List<Object?> get props => [id];
}

class ReorderCategories extends CategoryEvent {
  final List<Categoria> categories;

  const ReorderCategories(this.categories);

  @override
  List<Object?> get props => [categories];
}
