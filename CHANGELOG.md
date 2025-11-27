# Changelog - Finora

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

## [1.0.0] - 2024-11-24

### ✨ Adicionado

#### Arquitetura
- Implementação completa de **Clean Architecture**
- Camada de **Domain** com entidades e repositórios abstratos
- Camada de **Data** com modelos, datasources e implementações
- Camada de **Presentation** com BLoCs e UI

#### State Management
- **TransactionBloc** para gerenciar transações (CRUD completo)
- **CategoryBloc** para gerenciar categorias
- **FilterBloc** para estado dos filtros
- **ThemeBloc** para alternância de tema

#### Database
- Integração com **SQLite** via sqflite
- Tabelas: `transactions` e `categories`
- Índices para otimização de queries
- 10 categorias pré-configuradas
- Database Helper com migrations

#### UI/UX
- **HomePage** (Dashboard)
  - Card de saldo com gradiente e animações
  - Lista de transações recentes
  - Pull-to-refresh
  - Bottom navigation bar
  
- **AddTransactionPage**
  - Seletor visual de tipo (Receita/Despesa)
  - Campo de valor com validação
  - Seleção de categoria com ícones
  - Date picker integrado
  - Campo de notas opcional
  
- **ReportsPage**
  - Navegação entre meses
  - Cards de resumo (Receitas/Despesas)
  - Gráfico de pizza (FL Chart)
  - Lista detalhada com porcentagens
  - Barras de progresso visuais
  
- **CategoriesPage**
  - Listagem de categorias com ícones e cores
  - Visual clean e organizado

#### Widgets Customizados
- **BalanceCard** - Card animado de saldo com gradiente
- **TransactionListItem** - Item de lista com Slidable

#### Tema
- **Light Mode** completo com paleta moderna
- **Dark Mode** completo com cores adaptadas
- Alternância instantânea entre temas
- Google Fonts (Inter) para tipografia elegante
- Material Design 3

#### Utilitários
- **CurrencyFormatter** - Formatação de valores monetários (R$)
- **DateFormatter** - Formatação de datas (pt_BR)
- Constantes centralizadas

#### Serviços
- **ExportService** (preparado para futuras implementações)
  - Estrutura para exportação PDF
  - Estrutura para exportação Excel
  - Estrutura para exportação CSV

### 🎨 Design

- Paleta de cores moderna e vibrante
- 12 cores pré-definidas para categorias
- Gradientes suaves
- Sombras sutis para profundidade
- Bordas arredondadas (12-20px)
- Espaçamento consistente (8px, 16px, 24px)
- Ícones Material Design

### 📚 Documentação

- README.md completo com instruções
- GUIA_USO.md para usuários finais
- Comentários em código quando necessário
- Estrutura de projeto bem documentada

### 🔧 Dependências

#### Principais
- `flutter_bloc: ^8.1.3` - State management
- `sqflite: ^2.3.0` - Database local
- `fl_chart: ^0.65.0` - Gráficos
- `google_fonts: ^6.1.0` - Tipografia
- `animations: ^2.0.8` - Animações avançadas
- `flutter_slidable: ^3.0.1` - Gestos de deslizar
- `intl: ^0.19.0` - Internacionalização

#### Complementares
- `equatable: ^2.0.5` - Comparação de objetos
- `path_provider: ^2.1.1` - Paths do sistema
- `pdf: ^3.10.7` - Geração de PDFs
- `excel: ^4.0.3` - Geração de Excel
- `csv: ^6.0.0` - Geração de CSV

### ⚡ Performance

- Queries otimizadas com índices
- Lazy loading de transações (últimas 10)
- Animações de 200-500ms
- Database local (offline-first)

### 🎯 Features Principais

1. **Adicionar Transações**
   - Receitas e despesas
   - Categorização
   - Notas opcionais
   - Seleção de data

2. **Dashboard Interativo**
   - Saldo atualizado em tempo real
   - Resumo visual
   - Transações recentes

3. **Relatórios Visuais**
   - Gráfico de pizza
   - Análise por categoria
   - Navegação mensal

4. **Modo Escuro**
   - Alternância fácil
   - Cores adaptadas
   - Preservação de contraste

### 📱 Plataformas Suportadas

- ✅ Android
- ✅ iOS (preparado)
- ✅ Web (preparado)

### 🔒 Segurança

- Dados armazenados localmente
- Sem conexão com internet necessária
- Privacidade total do usuário

---

## [Futuras Versões]

### 🚀 Planejado para v1.1.0

- [ ] Edição de transações
- [ ] Exclusão em lote
- [ ] Exportação funcional (PDF, Excel, CSV)
- [ ] Compartilhamento de relatórios

### 🎯 Planejado para v1.2.0

- [ ] CRUD completo de categorias
- [ ] Reordenação de categorias (drag & drop)
- [ ] Ícones customizados
- [ ] Cores customizadas

### 📊 Planejado para v1.3.0

- [ ] Gráfico de linha (evolução temporal)
- [ ] Gráfico de barras (comparação mensal)
- [ ] Filtros avançados em todas as telas
- [ ] Busca de transações

### 💡 Planejado para v2.0.0

- [ ] Metas financeiras
- [ ] Orçamento por categoria
- [ ] Alertas de gastos
- [ ] Notificações push
- [ ] Múltiplas contas/carteiras
- [ ] Backup na nuvem
- [ ] Sincronização entre dispositivos

---

## Formato do Changelog

Este changelog segue as convenções de [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/).

### Tipos de Mudanças

- **Adicionado** para novas funcionalidades
- **Modificado** para mudanças em funcionalidades existentes
- **Descontinuado** para funcionalidades que serão removidas
- **Removido** para funcionalidades removidas
- **Corrigido** para correções de bugs
- **Segurança** para vulnerabilidades corrigidas
