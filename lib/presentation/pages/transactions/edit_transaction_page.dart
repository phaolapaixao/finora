import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/category.dart' as entity;
import '../../../domain/entities/transaction.dart' as entity;
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_state.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';

class EditTransactionPage extends StatefulWidget {
  final entity.Transaction transaction;

  const EditTransactionPage({super.key, required this.transaction});

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  late entity.TransactionType _type;
  entity.Categoria? _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.transaction.amount.toStringAsFixed(2),
    );
    _noteController = TextEditingController(text: widget.transaction.note);
    _type = widget.transaction.type;
    _selectedDate = widget.transaction.date;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Transação')),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoaded) {
            // Garantir que a categoria selecionada respeite o tipo atual
            final typeString = _type == entity.TransactionType.income
                ? 'income'
                : 'expense';
            final filtered = state.categories
                .where((cat) => cat.type == typeString)
                .toList();

            // Set selected category if not already set
            if (_selectedCategory == null && filtered.isNotEmpty) {
              final currentCat = filtered.firstWhere(
                (cat) => cat.id == widget.transaction.categoryId,
                orElse: () => filtered.first,
              );
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _selectedCategory = currentCat;
                  });
                }
              });
            }

            // Update category if type changed
            if (_selectedCategory != null &&
                !filtered.any((c) => c.id == _selectedCategory?.id)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _selectedCategory = filtered.first;
                  });
                }
              });
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTypeSelector(theme),
                    const SizedBox(height: 24),
                    _buildAmountField(theme),
                    const SizedBox(height: 16),
                    _buildCategorySelector(state.categories, theme),
                    const SizedBox(height: 16),
                    _buildDateSelector(theme),
                    const SizedBox(height: 16),
                    _buildNoteField(theme),
                    const SizedBox(height: 32),
                    _buildSaveButton(theme),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildTypeSelector(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeOption(
              'Despesa',
              entity.TransactionType.expense,
              Icons.arrow_upward,
              Colors.red,
              theme,
            ),
          ),
          Expanded(
            child: _buildTypeOption(
              'Receita',
              entity.TransactionType.income,
              Icons.arrow_downward,
              Colors.green,
              theme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(
    String label,
    entity.TransactionType type,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    final isSelected = _type == type;

    return GestureDetector(
      onTap: () => setState(() {
        _type = type;
        _selectedCategory = null;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: color, width: 2) : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? color
                  : theme.iconTheme.color?.withValues(alpha: 0.5),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isSelected ? color : null,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField(ThemeData theme) {
    return TextFormField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Valor',
        prefixText: 'R\$ ',
        prefixIcon: Icon(Icons.attach_money),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Digite um valor';
        }
        final amount = double.tryParse(value.replaceAll(',', '.'));
        if (amount == null || amount <= 0) {
          return 'Digite um valor válido';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySelector(
    List<entity.Categoria> categories,
    ThemeData theme,
  ) {
    final typeString = _type == entity.TransactionType.income
        ? 'income'
        : 'expense';

    final filteredCategories = categories
        .where((cat) => cat.type == typeString)
        .toList();

    return DropdownButtonFormField<entity.Categoria>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Categoria',
        prefixIcon: Icon(Icons.category),
      ),
      items: filteredCategories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Row(
            children: [
              Icon(category.icon, color: category.color, size: 20),
              const SizedBox(width: 12),
              Text(category.nome),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedCategory = value),
      validator: (value) {
        if (value == null) {
          return 'Selecione uma categoria';
        }
        return null;
      },
    );
  }

  Widget _buildDateSelector(ThemeData theme) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() => _selectedDate = date);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Data',
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
        ),
      ),
    );
  }

  Widget _buildNoteField(ThemeData theme) {
    return TextFormField(
      controller: _noteController,
      decoration: const InputDecoration(
        labelText: 'Nota (opcional)',
        prefixIcon: Icon(Icons.note),
      ),
      maxLines: 3,
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return ElevatedButton.icon(
      onPressed: _saveTransaction,
      icon: const Icon(Icons.save),
      label: const Text('Salvar Alterações'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final amount = double.parse(_amountController.text.replaceAll(',', '.'));

      final updatedTransaction = widget.transaction.copyWith(
        amount: amount,
        categoryId: _selectedCategory!.id,
        type: _type,
        date: _selectedDate,
        note: _noteController.text.isEmpty ? null : _noteController.text,
      );

      context.read<TransactionBloc>().add(
        UpdateTransaction(updatedTransaction),
      );

      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Transação atualizada!')));
    }
  }
}
