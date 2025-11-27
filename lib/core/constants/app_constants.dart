class AppConstants {
  // Database
  static const String databaseName = 'finora.db';
  static const int databaseVersion = 2;

  // Tabelas
  static const String tabelaTrasacoes = 'transactions';
  static const String tabelaCategorias = 'categories';

  // Formatos de data
  static const String data = 'dd/MM/yyyy';
  static const String dataHora = 'dd/MM/yyyy HH:mm';
  static const String mesAno = 'MMMM yyyy';

  // Durações de animação
  static const Duration pequenaAnimacao = Duration(milliseconds: 200);
  static const Duration mediaAnimacao = Duration(milliseconds: 300);
  static const Duration longaAnimacao = Duration(milliseconds: 500);

  // Limites
  static const int maxTransactionsPerPage = 20;
  static const int maxCategoriesCount = 50;
}
