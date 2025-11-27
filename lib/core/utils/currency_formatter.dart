import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static String format(double value) {
    return _currencyFormat.format(value);
  }

  static String formatCompact(double value) {
    if (value.abs() >= 1000000) {
      return 'R\$ ${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return 'R\$ ${(value / 1000).toStringAsFixed(1)}K';
    }
    return format(value);
  }

  static double parse(String value) {
    // Remove o simbolo de moeda e formatações locais
    final cleanValue = value
        .replaceAll('R\$', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();
    return double.tryParse(cleanValue) ?? 0.0;
  }

  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }
}
