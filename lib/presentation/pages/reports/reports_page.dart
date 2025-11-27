import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/transaction.dart' as entity;
import '../../../domain/entities/category.dart' as cat_entity;
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_state.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../bloc/transaction/transaction_state.dart';
import '../../bloc/transaction/transaction_event.dart';
import '../../../utils/export_utils.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

enum ChartType { pie, bar, line, donut }

class _ReportsPageState extends State<ReportsPage> {
  DateTime _selectedMonth = DateTime.now();
  ChartType _selectedChart = ChartType.pie;

  @override
  void initState() {
    super.initState();
    _loadMonthData();
  }

  void _loadMonthData() {
    final startDate = DateFormatter.startOfMonth(_selectedMonth);
    final endDate = DateFormatter.endOfMonth(_selectedMonth);

    context.read<TransactionBloc>().add(
      LoadTransactionsByDateRange(startDate: startDate, endDate: endDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month - 1,
                );
              });
              _loadMonthData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedMonth = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month + 1,
                );
              });
              _loadMonthData();
            },
          ),
          IconButton(
            tooltip: 'Exportar CSV',
            icon: const Icon(Icons.table_chart),
            onPressed: () async {
              final tState = context.read<TransactionBloc>().state;
              if (tState is TransactionLoaded) {
                final result = await exportTransactionsToCsv(
                  tState.transactions,
                );
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result ?? 'Erro desconhecido')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nenhuma transação carregada')),
                );
              }
            },
          ),
          IconButton(
            tooltip: 'Exportar PDF',
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final tState = context.read<TransactionBloc>().state;
              if (tState is TransactionLoaded) {
                final result = await exportTransactionsToPdf(
                  tState.transactions,
                );
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result ?? 'Erro desconhecido')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nenhuma transação carregada')),
                );
              }
            },
          ),
        ],
      ),
      // Gráficos e conteúdo
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, transactionState) {
          return BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, categoryState) {
              if (transactionState is TransactionLoading ||
                  categoryState is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (transactionState is TransactionLoaded &&
                  categoryState is CategoryLoaded) {
                return _buildContent(
                  context,
                  transactionState,
                  categoryState.categories,
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TransactionLoaded state,
    List<cat_entity.Categoria> categories,
  ) {
    final theme = Theme.of(context);
    final categoryMap = {for (var c in categories) c.id: c};

    // Calcula despesas por categoria
    final Map<String, double> expensesByCategory = {};
    for (final transaction in state.transactions) {
      if (transaction.type == entity.TransactionType.expense) {
        expensesByCategory[transaction.categoryId] =
            (expensesByCategory[transaction.categoryId] ?? 0) +
            transaction.amount;
      }
    }

    final bool hasData = expensesByCategory.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month selector
          Center(
            child: Text(
              DateFormatter.formatMonthYear(_selectedMonth),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Chart type selector: sempre visível e com título
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
            child: Text(
              'Tipo de gráfico',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Card(
            elevation: 1,
            color: theme.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: hasData
                          ? () => setState(() {
                              _selectedChart = ChartType.pie;
                              print('DEBUG REPORTS: selected chart = pie');
                            })
                          : null,
                      icon: const Icon(Icons.pie_chart, size: 20),
                      label: const Text('Pizza'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            hasData && _selectedChart == ChartType.pie
                            ? theme.colorScheme.primary.withValues(alpha: 0.08)
                            : null,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: hasData
                          ? () => setState(() {
                              _selectedChart = ChartType.bar;
                              print('DEBUG REPORTS: selected chart = bar');
                            })
                          : null,
                      icon: const Icon(Icons.bar_chart, size: 20),
                      label: const Text('Barras'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            hasData && _selectedChart == ChartType.bar
                            ? theme.colorScheme.primary.withValues(alpha: 0.08)
                            : null,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: hasData
                          ? () => setState(() {
                              _selectedChart = ChartType.line;
                              print('DEBUG REPORTS: selected chart = line');
                            })
                          : null,
                      icon: const Icon(Icons.show_chart, size: 20),
                      label: const Text('Linha'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            hasData && _selectedChart == ChartType.line
                            ? theme.colorScheme.primary.withValues(alpha: 0.08)
                            : null,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: hasData
                          ? () => setState(() {
                              _selectedChart = ChartType.donut;
                              print('DEBUG REPORTS: selected chart = donut');
                            })
                          : null,
                      icon: const Icon(Icons.donut_large, size: 20),
                      label: const Text('Donut'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            hasData && _selectedChart == ChartType.donut
                            ? theme.colorScheme.primary.withValues(alpha: 0.08)
                            : null,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Summary cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Receitas',
                  state.totalIncome,
                  Colors.green,
                  theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Despesas',
                  state.totalExpense,
                  Colors.red,
                  theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Charts area
          if (expensesByCategory.isNotEmpty) ...[
            Text(
              'Despesas por Categoria',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Build selected chart
            Builder(
              builder: (context) {
                final entries = expensesByCategory.entries.toList();
                print(
                  'DEBUG REPORTS: building chart $_selectedChart with ${entries.length} entries',
                );

                switch (_selectedChart) {
                  case ChartType.bar:
                    final maxValue = entries
                        .map((e) => e.value)
                        .fold<double>(0, (a, b) => a > b ? a : b);
                    final barGroups = entries.asMap().entries.map((e) {
                      final idx = e.key;
                      final value = e.value.value;
                      return BarChartGroupData(
                        x: idx,
                        barRods: [
                          BarChartRodData(
                            toY: value,
                            color:
                                categoryMap[e.value.key]?.color ??
                                AppColors.primaryLight,
                            width: 20,
                          ),
                        ],
                      );
                    }).toList();

                    return SizedBox(
                      height: 260,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: (maxValue * 1.2).clamp(1, double.infinity),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final idx = value.toInt();
                                  if (idx < 0 || idx >= entries.length)
                                    return const SizedBox.shrink();
                                  final nome =
                                      categoryMap[entries[idx].key]?.nome ?? '';
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      nome,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                },
                                reservedSize: 40,
                              ),
                            ),
                          ),
                          barGroups: barGroups,
                        ),
                      ),
                    );

                  case ChartType.line:
                    // Expenses per day
                    final daysInMonth = DateTime(
                      _selectedMonth.year,
                      _selectedMonth.month + 1,
                      0,
                    ).day;
                    final Map<int, double> daySums = {
                      for (var d = 1; d <= daysInMonth; d++) d: 0.0,
                    };
                    for (final t in state.transactions) {
                      if (t.type == entity.TransactionType.expense &&
                          t.date.year == _selectedMonth.year &&
                          t.date.month == _selectedMonth.month) {
                        daySums[t.date.day] =
                            (daySums[t.date.day] ?? 0) + t.amount;
                      }
                    }

                    final spots = daySums.entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList();
                    final maxY = daySums.values.fold<double>(
                      0,
                      (a, b) => a > b ? a : b,
                    );

                    return SizedBox(
                      height: 260,
                      child: LineChart(
                        LineChartData(
                          minX: 1,
                          maxX: daysInMonth.toDouble(),
                          minY: 0,
                          maxY: (maxY * 1.2).clamp(1, double.infinity),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value % 5 != 0)
                                    return const SizedBox.shrink();
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: AppColors.primaryLight,
                              dotData: FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    );

                  case ChartType.donut:
                    return SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: entries.map((entry) {
                            final category = categoryMap[entry.key];
                            final percentage =
                                (entry.value / state.totalExpense) * 100;
                            return PieChartSectionData(
                              value: entry.value,
                              title: '${percentage.toStringAsFixed(0)}%',
                              color: category?.color ?? AppColors.primaryLight,
                              radius: 50,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: 70,
                        ),
                      ),
                    );

                  case ChartType.pie:
                    return SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: entries.map((entry) {
                            final category = categoryMap[entry.key];
                            final percentage =
                                (entry.value / state.totalExpense) * 100;

                            return PieChartSectionData(
                              value: entry.value,
                              title: '${percentage.toStringAsFixed(0)}%',
                              color: category?.color ?? AppColors.primaryLight,
                              radius: 60,
                              titleStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    );
                }
              },
            ),

            const SizedBox(height: 24),

            // Category list
            ...expensesByCategory.entries.map((entry) {
              final category = categoryMap[entry.key];
              final percentage = (entry.value / state.totalExpense) * 100;

              return _buildCategoryItem(
                category?.nome ?? 'Desconhecida',
                entry.value,
                percentage,
                category?.color ?? AppColors.primaryLight,
                category?.icon ?? Icons.help_outline,
                theme,
              );
            }),
          ],

          if (expensesByCategory.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.pie_chart_outline,
                      size: 64,
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma despesa neste período',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String label,
    double valor,
    Color cor,
    ThemeData tema,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: tema.textTheme.bodyMedium?.copyWith(
              color: cor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(valor),
            style: tema.textTheme.titleLarge?.copyWith(
              color: cor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    String nome,
    double quantia,
    double porcentagem,
    Color cor,
    IconData icone,
    ThemeData tema,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tema.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icone, color: cor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: tema.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: porcentagem / 100,
                    backgroundColor: cor.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(cor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(quantia),
                  style: tema.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${porcentagem.toStringAsFixed(1)}%',
                  style: tema.textTheme.bodySmall?.copyWith(color: cor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
