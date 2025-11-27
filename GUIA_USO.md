# 🚀 Guia Rápido - Finora

## Início Rápido

### 1. Primeira Execução
Ao abrir o app pela primeira vez, você verá:
- **Dashboard vazio** com o card de saldo zerado
- **10 categorias pré-configuradas** prontas para uso
- **Botão "Nova"** para adicionar sua primeira transação

### 2. Adicionar Transação

**Passo a passo:**
1. Toque no botão **"Nova"** na parte inferior
2. Escolha o **tipo**: Despesa (vermelho) ou Receita (verde)
3. Digite o **valor** (ex: 150.00)
4. Selecione a **categoria** do dropdown
5. Escolha a **data** (padrão: hoje)
6. Adicione uma **nota** (opcional)
7. Toque em **"Salvar Transação"**

✅ Pronto! A transação aparece no dashboard

### 3. Navegação

**Bottom Navigation Bar:**
- 🏠 **Início** - Dashboard com resumo e transações recentes
- 📊 **Relatórios** - Gráficos e análises
- 📂 **Categorias** - Lista de todas as categorias

### 4. Dashboard (Início)

**O que você vê:**
- **Card de Saldo** (topo)
  - Saldo total
  - Total de receitas
  - Total de despesas
  
- **Transações Recentes** (abaixo)
  - Últimas 10 transações
  - Deslize para a esquerda para **excluir**
  - Pull-to-refresh para atualizar

### 5. Relatórios

**Funcionalidades:**
- Navegue entre meses com as **setas** no topo
- Veja **cards resumo** (receitas e despesas)
- **Gráfico de pizza** mostra distribuição de despesas
- **Lista detalhada** com porcentagens por categoria

**Cores no gráfico:**
- Cada categoria tem sua cor única
- Fácil identificação visual

### 6. Categorias

**Categorias Padrão:**
- 🍔 Alimentação
- 🚗 Transporte
- 🏠 Moradia
- 💊 Saúde
- 📚 Educação
- 🎮 Lazer
- 🛒 Compras
- 💰 Salário
- 📈 Investimentos
- 📦 Outros

### 7. Dark/Light Mode

**Trocar tema:**
- Toque no ícone de **sol/lua** no canto superior direito
- Alternância instantânea entre temas
- Configuração salva automaticamente

## ⚡ Dicas Rápidas

### Organização
- Use categorias específicas para melhor análise
- Adicione notas para lembrar detalhes importantes
- Revise seus gastos mensalmente nos relatórios

### Performance
- O app funciona 100% offline
- Dados salvos localmente no SQLite
- Rápido e responsivo

### Gestos
- **Deslizar** transação → Excluir
- **Pull-to-refresh** → Atualizar lista
- **Tap** no card de saldo → (futuro: detalhes)

## 🎯 Fluxo de Uso Recomendado

### Diário
1. Adicione transações assim que fizer gastos
2. Verifique o saldo no dashboard

### Semanal
1. Revise transações recentes
2. Corrija erros se necessário

### Mensal
1. Acesse **Relatórios**
2. Analise gráfico de gastos
3. Identifique categorias com maior gasto
4. Planeje ajustes para o próximo mês

## 🔧 Solução de Problemas

### App não inicia?
```bash
flutter clean
flutter pub get
flutter run
```

### Erro no banco de dados?
- Desinstale e reinstale o app
- Dados serão resetados (10 categorias padrão)

### Gráfico não aparece?
- Certifique-se de ter despesas cadastradas
- Verifique se o mês selecionado tem transações

## 📱 Atalhos de Teclado (Debug)

- `R` - Hot reload
- `Shift + R` - Hot restart

## 🎨 Personalizações Futuras

Em breve você poderá:
- ✨ Criar categorias customizadas
- 📤 Exportar relatórios (PDF/Excel/CSV)
- 📊 Ver gráficos de tendência
- 🎯 Definir metas de gastos
- 🔔 Receber notificações

## 💡 Exemplos de Uso

### Exemplo 1: Controle Mensal
```
1. Início do mês: Adicione receita (Salário)
2. Durante o mês: Registre todos os gastos
3. Fim do mês: Veja relatório e analise
```

### Exemplo 2: Planejamento
```
1. Veja relatório do mês passado
2. Identifique categoria com maior gasto
3. Estabeleça meta de redução
4. Monitore durante o mês
```

---

**Finora** - Seu parceiro financeiro pessoal! 💰✨
