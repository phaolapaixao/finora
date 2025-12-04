import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/constants/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Tabela de Categorias
    await db.execute('''
      CREATE TABLE ${AppConstants.tabelaCategorias} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        icon_code_point INTEGER NOT NULL,
        icon_font_family TEXT NOT NULL,
        color_value INTEGER NOT NULL,
        order_index INTEGER NOT NULL DEFAULT 0,
        type TEXT NOT NULL DEFAULT 'expense'
      )
    ''');

    // Tabelas de Transações
    await db.execute('''
      CREATE TABLE ${AppConstants.tabelaTrasacoes} (
        id TEXT PRIMARY KEY,
        amount REAL NOT NULL,
        category_id TEXT NOT NULL,
        type TEXT NOT NULL,
        date INTEGER NOT NULL,
        note TEXT,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES ${AppConstants.tabelaCategorias} (id) ON DELETE CASCADE
      )
    ''');

    // Criação de índices para otimização de consultas
    await db.execute('''
      CREATE INDEX idx_transactions_date 
      ON ${AppConstants.tabelaTrasacoes}(date)
    ''');

    await db.execute('''
      CREATE INDEX idx_transactions_category 
      ON ${AppConstants.tabelaTrasacoes}(category_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_transactions_type 
      ON ${AppConstants.tabelaTrasacoes}(type)
    ''');

    // Inserir categorias padrão
    await _insertDefaultCategories(db);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Adicionar coluna 'type' na tabela categories se não existir
      await db.execute('''
        ALTER TABLE ${AppConstants.tabelaCategorias}
        ADD COLUMN type TEXT NOT NULL DEFAULT 'expense'
      ''');

    
      await db.execute('''
        UPDATE ${AppConstants.tabelaCategorias}
        SET type = 'income'
        WHERE id IN ('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11')
      ''');

    }
  }

  Future<void> _insertDefaultCategories(Database db) async {
    final defaultCategories = [
      // Categorias de Receitas (verde)
      {
        'id': '1',
        'name': 'Salário',
        'icon_code_point': 0xe263, // pagamentos
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF51CF66,
        'order_index': 0,
        'type': 'income',
      },
      {
        'id': '2',
        'name': 'Horas extras',
        'icon_code_point': 0xe8b5, // agendar
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF69DB7C,
        'order_index': 1,
        'type': 'income',
      },
      {
        'id': '3',
        'name': 'Comissão',
        'icon_code_point': 0xe8e5, // crescimento
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF8CE99A,
        'order_index': 2,
        'type': 'income',
      },
      {
        'id': '4',
        'name': 'Bônus / Gratificações',
        'icon_code_point': 0xeb3c, // cartão
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF40C057,
        'order_index': 3,
        'type': 'income',
      },
      {
        'id': '5',
        'name': 'Freelancer / Bicos',
        'icon_code_point': 0xe30e, // trabalho
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF37B24D,
        'order_index': 4,
        'type': 'income',
      },
      {
        'id': '6',
        'name': 'Gorjetas / Prêmios',
        'icon_code_point': 0xef51, 
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF2F9E44,
        'order_index': 5,
        'type': 'income',
      },
      {
        'id': '7',
        'name': 'Venda de bens',
        'icon_code_point': 0xe8cc, 
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF2B8A3E,
        'order_index': 6,
        'type': 'income',
      },
      {
        'id': '8',
        'name': 'Presentes em dinheiro',
        'icon_code_point': 0xebd5, 
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF94D82D,
        'order_index': 7,
        'type': 'income',
      },
      {
        'id': '9',
        'name': 'Herança',
        'icon_code_point': 0xe88a, 
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF82C91E,
        'order_index': 8,
        'type': 'income',
      },
      {
        'id': '10',
        'name': 'Reembolsos',
        'icon_code_point': 0xe8d0, 
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF74B816,
        'order_index': 9,
        'type': 'income',
      },
      {
        'id': '11',
        'name': 'Prêmios (Loteria)',
        'icon_code_point': 0xe8f5, 
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF66A80F,
        'order_index': 10,
        'type': 'income',
      },
      // Categorias de Despesas (vermelho/laranja)
      {
        'id': '12',
        'name': 'Alimentação',
        'icon_code_point': 0xe532, 
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFFFF6B6B,
        'order_index': 11,
        'type': 'expense',
      },
      {
        'id': '13',
        'name': 'Transporte',
        'icon_code_point': 0xe55d,
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF4ECDC4,
        'order_index': 12,
        'type': 'expense',
      },
      {
        'id': '14',
        'name': 'Moradia',
        'icon_code_point': 0xe88a, 
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFFFFE66D,
        'order_index': 13,
        'type': 'expense',
      },
      {
        'id': '15',
        'name': 'Saúde',
        'icon_code_point': 0xe3f3,
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF95E1D3,
        'order_index': 14,
        'type': 'expense',
      },
      {
        'id': '16',
        'name': 'Educação',
        'icon_code_point': 0xe80c, 
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFFF38181,
        'order_index': 15,
        'type': 'expense',
      },
      {
        'id': '17',
        'name': 'Lazer',
        'icon_code_point': 0xe30e, 
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFFAA96DA,
        'order_index': 16,
        'type': 'expense',
      },
      {
        'id': '18',
        'name': 'Compras',
        'icon_code_point': 0xe8cc,
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFFFCBF49,
        'order_index': 17,
        'type': 'expense',
      },
      {
        'id': '19',
        'name': 'Investimentos',
        'icon_code_point': 0xe8e5,
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF6A4C93,
        'order_index': 18,
        'type': 'expense',
      },
      {
        'id': '20',
        'name': 'Outros',
        'icon_code_point': 0xe8f9, 
        'icon_font_family': 'MaterialIcons',
        'color_value': 0xFF3A86FF,
        'order_index': 19,
        'type': 'expense',
      },
    ];

    for (final category in defaultCategories) {
      await db.insert(AppConstants.tabelaCategorias, category);
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
