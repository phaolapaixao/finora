import 'dart:io';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:finora/domain/entities/transaction.dart' as entity;
import 'package:intl/intl.dart';

/// Exporta transações para o formato CSV e abre o arquivo no visualizador de arquivos do dispositivo.
Future<String?> exportTransactionsToCsv(
  List<entity.Transaction> transactions,
) async {
  try {
    // Prepare CSV rows
    final List<List<dynamic>> rows = [
      ['Data', 'Categoria', 'Tipo', 'Descrição', 'Valor'],
    ];

    for (final t in transactions) {
      rows.add([
        DateFormat('dd/MM/yyyy').format(t.date),
        t.categoryId,
        t.type == entity.TransactionType.income ? 'Receita' : 'Despesa',
        t.note ?? '',
        t.amount.toStringAsFixed(2),
      ]);
    }

    final String csv = const ListToCsvConverter().convert(rows);

    // Obtém o diretório de cache (sem necessidade de permissões)
    final Directory cacheDir = await getTemporaryDirectory();
    final Directory exportsDir = Directory('${cacheDir.path}/exports');
    if (!await exportsDir.exists()) {
      await exportsDir.create(recursive: true);
    }

    final String timestamp = DateFormat(
      'yyyyMMdd_HHmmss',
    ).format(DateTime.now());
    final String filePath =
        '${exportsDir.path}/finora_transacoes_$timestamp.csv';
    final File file = File(filePath);

    await file.writeAsString(csv, flush: true);

    // abre o arquivo usando o visualizador de arquivos do dispositivo
    await OpenFile.open(filePath);

    return 'CSV exportado com sucesso!\n$filePath';
  } catch (e) {
    return 'Erro ao exportar CSV: $e';
  }
}

/// Exporta transações para o formato PDF e abre o arquivo.
Future<String?> exportTransactionsToPdf(
  List<entity.Transaction> transactions,
) async {
  try {
    final pdf = pw.Document();

    // Calcula totais
    double totalIncome = 0;
    double totalExpense = 0;
    for (final t in transactions) {
      if (t.type == entity.TransactionType.income) {
        totalIncome += t.amount;
      } else {
        totalExpense += t.amount;
      }
    }

    // Prepara tabela de dados
    final List<List<String>> tableData = transactions.map((t) {
      return [
        DateFormat('dd/MM/yyyy').format(t.date),
        t.categoryId,
        t.type == entity.TransactionType.income ? 'Receita' : 'Despesa',
        t.note ?? '-',
        'R\$ ${t.amount.toStringAsFixed(2)}',
      ];
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            pw.Header(level: 0, child: pw.Text('Relatório de Transações')),
            pw.SizedBox(height: 8),
            pw.Text('Receitas: R\$ ${totalIncome.toStringAsFixed(2)}'),
            pw.Text('Despesas: R\$ ${totalExpense.toStringAsFixed(2)}'),
            pw.Text(
              'Saldo: R\$ ${(totalIncome - totalExpense).toStringAsFixed(2)}',
            ),
            pw.SizedBox(height: 12),
            pw.Table.fromTextArray(
              headers: ['Data', 'Categoria', 'Tipo', 'Descrição', 'Valor'],
              data: tableData,
            ),
          ];
        },
      ),
    );

    // Obtém o diretório de cache (sem necessidade de permissões)
    final Directory cacheDir = await getTemporaryDirectory();
    final Directory exportsDir = Directory('${cacheDir.path}/exports');
    if (!await exportsDir.exists()) {
      await exportsDir.create(recursive: true);
    }

    final String timestamp = DateFormat(
      'yyyyMMdd_HHmmss',
    ).format(DateTime.now());
    final String filePath =
        '${exportsDir.path}/finora_relatorio_$timestamp.pdf';
    final File file = File(filePath);

    final bytes = await pdf.save();
    await file.writeAsBytes(bytes, flush: true);

    await OpenFile.open(filePath);

    return 'PDF exportado com sucesso!\n$filePath';
  } catch (e) {
    return 'Erro ao exportar PDF: $e';
  }
}
