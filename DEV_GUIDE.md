# 🛠️ Guia de Desenvolvimento - Finora

## Para Desenvolvedores

Este documento é para você que quer contribuir, entender a arquitetura ou expandir o projeto.

---

## 🏗️ Arquitetura Clean Architecture

### Camadas

```
┌─────────────────────────────────────┐
│         PRESENTATION                │  ← UI, BLoCs, Widgets
├─────────────────────────────────────┤
│           DOMAIN                    │  ← Entities, Repositories (interfaces)
├─────────────────────────────────────┤
│            DATA                     │  ← Models, DataSources, Repo Implementations
└─────────────────────────────────────┘
```

### Fluxo de Dados

```
UI → Event → BLoC → Repository → DataSource → Database
                     ↓
UI ← State ← BLoC ← Repository ← DataSource ← Database
```

---

## 📦 Estrutura de Pastas

```
lib/
├── core/                      # Código compartilhado
│   ├── constants/            # Constantes da app
│   ├── theme/                # Temas e cores
│   ├── utils/                # Utilitários e formatters
│   └── services/             # Serviços (export, etc)
│
├── domain/                   # Regras de negócio
│   ├── entities/            # Entidades puras
│   │   ├── transaction.dart
│   │   └── category.dart
│   └── repositories/        # Contratos (interfaces)
│       ├── transaction_repository.dart
│       └── category_repository.dart
│
├── data/                    # Implementações concretas
│   ├── datasources/        # Acesso a dados
│   │   └── database_helper.dart
│   ├── models/             # Models com serialização
│   │   ├── transaction_model.dart
│   │   └── category_model.dart
│   └── repositories/       # Implementações dos repos
│       ├── transaction_repository_impl.dart
│       └── category_repository_impl.dart
│
└── presentation/           # Interface e lógica de apresentação
    ├── bloc/              # Gerenciamento de estado
    │   ├── transaction/
    │   ├── category/
    │   ├── filter/
    │   └── theme/
    ├── pages/            # Telas principais
    │   ├── home/
    │   ├── transactions/
    │   ├── reports/
    │   └── categories/
    └── widgets/          # Widgets reutilizáveis
```

---

## 🎯 Como Adicionar Novas Features

### 1. Adicionar Nova Entidade

**Exemplo: Adicionar "Budget" (Orçamento)**

```dart
// lib/domain/entities/budget.dart
import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final String? id;
  final String categoryId;
  final double limit;
  final DateTime month;

  const Budget({
    this.id,
    required this.categoryId,
    required this.limit,
    required this.month,
  });

  @override
  List<Object?> get props => [id, categoryId, limit, month];
}
```

### 2. Criar Repository Interface

```dart
// lib/domain/repositories/budget_repository.dart
abstract class BudgetRepository {
  Future<List<Budget>> getBudgets();
  Future<Budget?> getBudgetById(String id);
  Future<String> addBudget(Budget budget);
  Future<void> updateBudget(Budget budget);
  Future<void> deleteBudget(String id);
}
```

### 3. Criar Model

```dart
// lib/data/models/budget_model.dart
class BudgetModel extends Budget {
  const BudgetModel({
    super.id,
    required super.categoryId,
    required super.limit,
    required super.month,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String?,
      categoryId: json['category_id'] as String,
      limit: (json['limit'] as num).toDouble(),
      month: DateTime.fromMillisecondsSinceEpoch(json['month'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'limit': limit,
      'month': month.millisecondsSinceEpoch,
    };
  }
}
```

### 4. Implementar Repository

```dart
// lib/data/repositories/budget_repository_impl.dart
class BudgetRepositoryImpl implements BudgetRepository {
  final DatabaseHelper databaseHelper;

  BudgetRepositoryImpl({required this.databaseHelper});

  @override
  Future<List<Budget>> getBudgets() async {
    final db = await databaseHelper.database;
    final maps = await db.query('budgets');
    return maps.map((map) => BudgetModel.fromJson(map)).toList();
  }
  
  // ... outras implementações
}
```

### 5. Criar BLoC

```dart
// lib/presentation/bloc/budget/budget_bloc.dart
class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetRepository repository;

  BudgetBloc({required this.repository}) : super(BudgetInitial()) {
    on<LoadBudgets>(_onLoadBudgets);
    on<AddBudget>(_onAddBudget);
    // ... outros eventos
  }
}
```

### 6. Criar UI

```dart
// lib/presentation/pages/budget/budget_page.dart
class BudgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetBloc, BudgetState>(
      builder: (context, state) {
        // ... build UI
      },
    );
  }
}
```

---

## 🔧 Comandos Úteis

### Desenvolvimento

```bash
# Executar app
flutter run

# Hot reload (durante execução)
r

# Hot restart (durante execução)
R

# Análise de código
flutter analyze

# Formatar código
flutter format lib/

# Limpar cache
flutter clean
```

### Database

```bash
# Ver tabelas (Android)
adb shell
cd /data/data/com.example.finora/databases
sqlite3 finora.db
.tables
.schema transactions
SELECT * FROM transactions;
```

### Testes

```bash
# Rodar todos os testes
flutter test

# Teste específico
flutter test test/transaction_bloc_test.dart

# Com coverage
flutter test --coverage
```

---

## 🎨 Padrões de Código

### Nomenclatura

- **Classes**: `PascalCase` (ex: `TransactionBloc`)
- **Variáveis**: `camelCase` (ex: `totalExpense`)
- **Constantes**: `camelCase` (ex: `primaryColor`)
- **Arquivos**: `snake_case` (ex: `transaction_bloc.dart`)

### Estrutura de Widgets

```dart
class MyWidget extends StatelessWidget {
  // 1. Parâmetros
  final String title;
  final VoidCallback onTap;

  // 2. Construtor
  const MyWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  // 3. Build
  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  // 4. Métodos privados
  Widget _buildContent(BuildContext context) {
    // ...
  }
}
```

### BLoC Pattern

```dart
// Event
abstract class MyEvent extends Equatable {
  const MyEvent();
  @override
  List<Object?> get props => [];
}

// State
abstract class MyState extends Equatable {
  const MyState();
  @override
  List<Object?> get props => [];
}

// BLoC
class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(MyInitial()) {
    on<MyEvent>(_onMyEvent);
  }

  Future<void> _onMyEvent(
    MyEvent event,
    Emitter<MyState> emit,
  ) async {
    // Lógica
  }
}
```

---

## 🐛 Debug Tips

### Print Statements

```dart
// Use debugPrint para logs
debugPrint('Transaction added: ${transaction.id}');

// BLoC logging
@override
void onChange(Change<TransactionState> change) {
  super.onChange(change);
  debugPrint('TransactionBloc: $change');
}
```

### Flutter DevTools

```bash
# Abrir DevTools
flutter pub global activate devtools
flutter pub global run devtools

# Ou durante execução, pressione 'w'
```

### Erros Comuns

**1. Provider not found**
```dart
// ❌ Errado
context.read<TransactionBloc>()

// ✅ Correto - certifique-se que BlocProvider está acima
BlocProvider(
  create: (context) => TransactionBloc(...),
  child: MyWidget(),
)
```

**2. Database locked**
```dart
// Use transactions para operações múltiplas
await db.transaction((txn) async {
  await txn.insert(...);
  await txn.update(...);
});
```

---

## 📊 Performance Tips

### 1. Use const constructors

```dart
// ✅ Bom
const Text('Hello')

// ❌ Evitar
Text('Hello')
```

### 2. ListView.builder para listas grandes

```dart
// ✅ Bom - lazy loading
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => Item(items[index]),
)

// ❌ Evitar - carrega tudo
ListView(children: items.map((i) => Item(i)).toList())
```

### 3. Keys para animações

```dart
// Use keys quando itens podem ser reordenados
ListView(
  children: items.map((item) => 
    MyWidget(key: ValueKey(item.id), item: item)
  ).toList(),
)
```

---

## 🎨 UI Guidelines

### Espaçamentos Padrão

- Extra small: `4px`
- Small: `8px`
- Medium: `16px`
- Large: `24px`
- Extra large: `32px`

### Bordas Arredondadas

- Pequenas: `8px`
- Médias: `12px`
- Grandes: `16px`
- Extra grandes: `20px`

### Animações

- Rápida: `200ms`
- Média: `300ms`
- Lenta: `500ms`

---

## 🔐 Boas Práticas

1. **Sempre use BLoC para state management**
2. **Mantenha widgets pequenos e focados**
3. **Extraia constantes para arquivos separados**
4. **Comente código complexo**
5. **Use meaningful names**
6. **Teste suas features**
7. **Mantenha a arquitetura limpa**

---

## 📚 Recursos

- [Flutter Docs](https://docs.flutter.dev/)
- [BLoC Library](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Material Design 3](https://m3.material.io/)

---

**Happy Coding! 🚀**
