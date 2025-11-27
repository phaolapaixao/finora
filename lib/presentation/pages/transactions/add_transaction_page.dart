import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/category.dart' as entity;
import '../../../domain/entities/transaction.dart' as entity;
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_state.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_event.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  entity.TransactionType _type = entity.TransactionType.expense;
  entity.Categoria? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

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
      appBar: AppBar(title: const Text('Nova Transação')),
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

            if (filtered.isNotEmpty &&
                (_selectedCategory == null ||
                    !filtered.any((c) => c.id == _selectedCategory?.id))) {
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
        _selectedCategory = null; // Resetar categoria ao mudar tipo
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
                color: isSelected ? color : theme.textTheme.bodyMedium?.color,
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
      decoration: InputDecoration(
        labelText: 'Valor',
        prefixText: 'R\$ ',
        prefixStyle: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe o valor';
        }
        final amount = double.tryParse(value.replaceAll(',', '.'));
        if (amount == null || amount <= 0) {
          return 'Valor inválido';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySelector(
    List<entity.Categoria> categories,
    ThemeData theme,
  ) {
    // Filtrar categorias baseado no tipo de transação
    final typeString = _type == entity.TransactionType.income
        ? 'income'
        : 'expense';

    final filteredCategories = categories
        .where((cat) => cat.type == typeString)
        .toList();

    // Se a categoria selecionada não está na lista filtrada ou é null, selecionar a primeira
    if (filteredCategories.isNotEmpty &&
        (_selectedCategory == null ||
            !filteredCategories.any(
              (cat) => cat.id == _selectedCategory?.id,
            ))) {
      // Usar addPostFrameCallback para evitar chamar setState durante o build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedCategory = filteredCategories.first;
          });
        }
      });
    }

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
          style: theme.textTheme.bodyLarge,
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
    return ElevatedButton(
      onPressed: _saveTransaction,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('Salvar Transação'),
    );
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final amount = double.parse(_amountController.text.replaceAll(',', '.'));

      final transaction = entity.Transaction(
        amount: amount,
        categoryId: _selectedCategory!.id!,
        type: _type,
        date: _selectedDate,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        createdAt: DateTime.now(),
      );

      context.read<TransactionBloc>().add(AddTransaction(transaction));

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transação adicionada com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
