import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/category.dart';
import '../utils/currency_formatter.dart';
import '../utils/date_formatter.dart';

class ExportService {
  // Exportar para PDF
  Future<File> exportToPdf(
    List<Transaction> transacoes,
    Map<String, Categoria> categorias,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Relatório Financeiro - Finora',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['Data', 'Categoria', 'Tipo', 'Valor', 'Nota'],
            data: transacoes.map((t) {
              final categoria = categorias[t.categoryId];
              return [
                DateFormatter.formatDate(t.date),
                categoria?.nome ?? 'Sem categoria',
                t.type == TransactionType.income ? 'Receita' : 'Despesa',
                CurrencyFormatter.format(t.amount),
                t.note ?? '-',
              ];
            }).toList(),
          ),
        ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/finora_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  // Exportar para Excel
  Future<File> exportToExcel(
    List<Transaction> transactions,
    Map<String, Categoria> categories,
  ) async {
    final excel = Excel.createExcel();
    final sheet = excel['Transações'];

    // Headers
    sheet.appendRow([
      TextCellValue('Data'),
      TextCellValue('Categoria'),
      TextCellValue('Tipo'),
      TextCellValue('Valor'),
      TextCellValue('Nota'),
    ]);

    // Dados
    for (final transaction in transactions) {
      final category = categories[transaction.categoryId];
      sheet.appendRow([
        TextCellValue(DateFormatter.formatDate(transaction.date)),
        TextCellValue(category?.nome ?? 'Sem categoria'),
        TextCellValue(
          transaction.type == TransactionType.income ? 'Receita' : 'Despesa',
        ),
        DoubleCellValue(transaction.amount),
        TextCellValue(transaction.note ?? ''),
      ]);
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/finora_${DateTime.now().millisecondsSinceEpoch}.xlsx',
    );
    await file.writeAsBytes(excel.encode()!);

    return file;
  }

  // Exportar para CSV
  Future<File> exportToCsv(
    List<Transaction> transacoes,
    Map<String, Categoria> categorias,
  ) async {
    final List<List<dynamic>> rows = [
      ['Data', 'Categoria', 'Tipo', 'Valor', 'Nota'],
    ];

    for (final transacao in transacoes) {
      final categoria = categorias[transacao.categoryId];
      rows.add([
        DateFormatter.formatDate(transacao.date),
        categoria?.nome ?? 'Sem categoria',
        transacao.type == TransactionType.income ? 'Receita' : 'Despesa',
        transacao.amount,
        transacao.note ?? '',
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/finora_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString(csv);

    return file;
  }
}
