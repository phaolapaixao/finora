# 💰 Finora - Gerenciador Financeiro Moderno

Um aplicativo Flutter completo de gerenciamento financeiro pessoal com **arquitetura limpa**, **BLoC** e **design moderno**.

## ✨ Características

### 🎨 Interface do Usuário
- **Design minimalista e moderno** com animações fluidas
- **Dark/Light Mode** com transições suaves
- **Cards com gradientes** e sombras sutis
- **Microinterações** para melhor experiência do usuário
- **Material Design 3** com Google Fonts (Inter)

### 🏗️ Arquitetura
- **Clean Architecture** (Domain, Data, Presentation)
- **BLoC Pattern** para gerenciamento de estado
- **Repository Pattern** para abstração de dados
- Separação clara de responsabilidades

### 📊 Funcionalidades Principais
- ✅ **Dashboard intuitivo** com resumo financeiro
- ✅ **Adicionar transações** (Receitas/Despesas)
- ✅ **Categorias personalizadas** com ícones e cores
- ✅ **Relatórios visuais** com gráficos interativos (FL Chart)
- ✅ **Filtros avançados** por data, categoria e tipo
- ✅ **Banco de dados local** (SQLite)
- ✅ **Tema claro e escuro**

### 🎯 BLoCs Implementados
- **TransactionBloc** - Gerenciamento de transações
- **CategoryBloc** - Gerenciamento de categorias
- **FilterBloc** - Estado dos filtros
- **ThemeBloc** - Tema da aplicação

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK ^3.9.2
- Dart SDK ^3.9.2

### Instalação

1. **Clone o repositório**
```bash
git clone <seu-repositorio>
cd finora
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute o app**
```bash
flutter run
```

## 📦 Dependências Principais

```yaml
# State Management
flutter_bloc: ^8.1.3
equatable: ^2.0.5

# Database
sqflite: ^2.3.0

# Charts
fl_chart: ^0.65.0

# UI/UX
animations: ^2.0.8
shimmer: ^3.0.0
google_fonts: ^6.1.0
flutter_slidable: ^3.0.1

# Utilities
intl: ^0.19.0
path_provider: ^2.1.1
```

## 🗂️ Estrutura do Projeto

```
lib/
├── core/
│   ├── constants/     # Constantes da aplicação
│   ├── theme/         # Temas (cores, estilos)
│   └── utils/         # Utilitários (formatters)
├── domain/
│   ├── entities/      # Entidades de negócio
│   └── repositories/  # Interfaces dos repositórios
├── data/
│   ├── datasources/   # Database Helper (SQLite)
│   ├── models/        # Models com toJson/fromJson
│   └── repositories/  # Implementações dos repositórios
└── presentation/
    ├── bloc/          # BLoCs (State Management)
    ├── pages/         # Telas da aplicação
    └── widgets/       # Widgets reutilizáveis
```

## 🎨 Paleta de Cores

### Light Mode
- Primary: `#6C63FF`
- Secondary: `#00D4AA`
- Background: `#F8F9FE`
- Error: `#FF6B6B`
- Success: `#51CF66`

### Dark Mode
- Primary: `#8B83FF`
- Secondary: `#00F5C4`
- Background: `#0F1419`
- Surface: `#1A202C`

## 🔥 Funcionalidades em Destaque

### Dashboard
- Card de saldo com gradiente animado
- Resumo de receitas e despesas
- Lista de transações recentes
- Pull-to-refresh

### Adicionar Transação
- Seletor visual de tipo (Receita/Despesa)
- Campo de valor com formatação automática
- Seleção de categoria com ícones
- Calendário para escolha de data
- Campo de notas opcional

### Relatórios
- Navegação por mês
- Gráfico de pizza (despesas por categoria)
- Cards de resumo
- Lista detalhada com porcentagens
- Barras de progresso visuais

### Categorias
- Listagem de todas as categorias
- Ícones e cores personalizadas
- 10 categorias pré-configuradas

## 🎯 Próximas Funcionalidades

- [ ] Exportação para PDF, Excel e CSV
- [ ] Edição de transações
- [ ] Gráficos de linha (evolução temporal)
- [ ] Metas financeiras
- [ ] Notificações e lembretes
- [ ] Backup na nuvem
- [ ] Múltiplas contas/carteiras

## 🧪 Testes

```bash
flutter test
```

## 📱 Screenshots

_(Adicione screenshots do seu app aqui)_

## 👨‍💻 Desenvolvido com

- Flutter
- Dart
- SQLite
- BLoC Pattern
- Clean Architecture

## 📄 Licença

Este projeto é de código aberto e está disponível sob a licença MIT.

---

**Finora** - Controle suas finanças com estilo 💎

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
