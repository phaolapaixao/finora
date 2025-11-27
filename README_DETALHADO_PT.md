# Finora — Guia Detalhado para Iniciantes

Este documento explica, passo a passo, o que é este projeto, como executar o aplicativo e como navegar pelo código — escrito de forma simples, como se você nunca tivesse visto programação antes.

⚠️ Observação: este é o código-fonte do aplicativo. Para usar o app no celular você pode instalar uma versão pronta (se existir). Aqui mostramos como executar e modificar o código localmente.

---

## O que é este projeto?

- Nome: Finora
- O que faz: é um aplicativo para gerenciar finanças pessoais (anotar receitas e despesas, organizar por categorias, ver relatórios e exportar relatórios em PDF/CSV).
- Público-alvo: pessoas que querem controlar gastos e receitas no celular.

Em termos leigos: pense nele como um caderno digital para registrar dinheiro que entra e sai, com gráficos para mostrar para onde você está gastando.

---

## Como usar o aplicativo (para quem vai apenas usar o app)

1. Abra o aplicativo no seu celular (se estiver instalado). Se for usar a versão de desenvolvimento, siga as instruções na seção "Executar o app (desenvolvedores)".
2. Tela principal / Dashboard: mostra o saldo (total de receitas - despesas) e transações recentes.
3. Adicionar transação: procure o botão de adicionar (geralmente um botão flutuante com "+"). Preencha: tipo (Receita ou Despesa), valor, data, categoria, nota (opcional). Salve.
4. Editar / Apagar: em cada item da lista há pequenos ícones (caneta = editar, lixeira = apagar). Toque para editar ou confirmar exclusão.
5. Relatórios: acesse a tela "Relatórios" para ver gráficos e cartões de resumo. Há ações para exportar em PDF ou CSV; ao exportar o app tenta abrir o arquivo automaticamente.

Onde o arquivo é salvo? O app salva em uma pasta temporária do próprio aplicativo e tenta abrir o arquivo com o visualizador do aparelho. Em alguns aparelhos o arquivo pode aparecer no gerenciador de arquivos; em outros, o app apenas abre o arquivo para visualização.

---

## Executar o app (desenvolvedores) — passo a passo mínimo (Windows)

O que você precisa antes de começar:
- Um computador com Windows.
- Instalar o Flutter SDK (siga as instruções em https://flutter.dev). Isso instala também o Dart.
- Um emulador Android (Android Studio) ou um dispositivo Android conectado via USB (com Depuração USB ativada).

Passos:

1. Abra o PowerShell e vá para a pasta onde quer clonar o projeto.

```powershell
# Clonar o repositório (substitua pela URL real)
git clone <url-do-repositorio>
cd finora
```

2. Instalar dependências:

```powershell
flutter pub get
```

3. Executar o app no emulador/dispositivo:

```powershell
flutter run
```

Se quiser apenas compilar uma vez e ver mensagens no console, rode `flutter run` e acompanhe as mensagens que aparecem no PowerShell.

Dicas:
- Se algo não atualizar como esperado depois de editar o código, experimente `r` (hot reload) no console do `flutter run`. Para alterações maiores (por exemplo, mudanças em assets, temas ou rotas), faça `R` (hot restart) ou pare e rode `flutter run` novamente.
- Se der erro de build, tente:

```powershell
flutter clean
flutter pub get
flutter run
```

---

## Estrutura do projeto (explicada de forma simples)

Pasta principal: `lib/` — contém o código do aplicativo.

- `lib/core/` — utilitários e temas. Coisas que são usadas por todo o app (cores, formatações, serviços).
- `lib/domain/` — modelos e contratos (aqui fica a definição das entidades: por exemplo, o que é uma "Transaction"). Pense nisso como o dicionário do app.
- `lib/data/` — onde os dados são lidos e gravados (conexão com o banco local). Aqui existe o acesso ao SQLite (o banco de dados que guarda as transações no celular).
- `lib/presentation/` — a parte que mostra telas e widgets (o que o usuário vê). Contém `pages/` (telas) e `widgets/` (pequenos componentes reutilizáveis).
- `android/` e `ios/` — configuração e código específico das plataformas (normalmente não precisa mexer aqui para mudanças simples no app).

Arquitetura resumida (palavras simples): o app separa claramente o que é "dados", o que é "regras" e o que é "tela", para deixar o código organizado e mais fácil de manter.

---

## Principais funcionalidades e onde procurar o código

- Adicionar transação: `lib/presentation/pages/...` (procure por `add_transaction` ou telas relacionadas).
- Editar transação: `lib/presentation/pages/transactions/edit_transaction_page.dart`.
- Lista de transações: `lib/presentation/widgets/transaction_list_item.dart`.
- Exportar PDF/CSV: `lib/utils/export_utils.dart` e `lib/core/services/export_service.dart`.
- Banco de dados (SQLite): `lib/data/datasources/database_helper.dart` e repositórios em `lib/data/repositories/`.

Se quiser apenas ver onde uma função está definida, use a busca do editor (CTRL+P / CTRL+F) e digite o nome.

---

## Como modificar o texto que aparece na tela (ex.: traduzir labels)

1. Abra o arquivo onde o texto é mostrado. Por exemplo: `lib/presentation/pages/reports/reports_page.dart`.
2. Localize o texto (por exemplo, `Text('Relatório de Transações')`).
3. Edite entre as aspas e salve.
4. Use hot reload (pressione `r` no console do `flutter run`) para ver a mudança na tela imediatamente.

Observação: nem todas as mudanças aparecem com hot reload; se não aparecer, pare e rode `flutter run` novamente.

---

## Testes básicos

Para executar os testes automatizados (se existirem):

```powershell
flutter test
```

Isso executa testes unitários que verificam se partes do código funcionam corretamente.

---

## Como contribuir (passos simples)

1. Crie uma cópia (branch) para sua mudança:

```powershell
git checkout -b minha-mudanca
```

2. Faça as alterações no código e salve.
3. Execute o app e verifique que não quebrou nada.
4. Adicione e faça commit:

```powershell
git add .
git commit -m "Descrição curta da mudança"
```

5. Envie para o repositório remoto e abra um Pull Request (se você usar GitHub/GitLab).

---

## Glossário (termos simples)

- Flutter: ferramenta para criar aplicativos para celular e web usando a linguagem Dart.
- Dart: linguagem de programação usada pelo Flutter.
- SDK: coleção de ferramentas e bibliotecas necessárias para programar (no caso, o Flutter SDK).
- Emulador: é um programa no computador que “finge” ser um celular para você testar o app.
- Hot reload: atualiza a tela do app rapidamente sem reiniciar tudo — útil ao editar o visual ou textos.
- Widget: bloco de construção visual no Flutter (botão, texto, card, etc.).
- BLoC: padrão para organizar estado do aplicativo (ajuda a separar lógica da interface).
- SQLite / sqflite: um banco de dados simples que roda dentro do seu celular para guardar dados localmente.

---

## Problemas comuns e soluções rápidas

- Erro de dependências: rode `flutter pub get`.
- App não atualiza depois de mudar o código: tente `r` (hot reload) ou `R` (hot restart), ou reinicie com `flutter run`.
- Erro de build: rode `flutter clean` e depois `flutter pub get` e `flutter run`.
- Ao exportar PDF/CSV nada aparece: o app tenta abrir o arquivo automaticamente; verifique se você tem um visualizador de PDF instalado no dispositivo.

---

## Próximos passos recomendados (para iniciantes que querem aprender)

1. Aprender o básico de programação (variáveis, funções) — tutoriais introdutórios em português.
2. Seguir um tutorial oficial do Flutter para criar uma tela simples.
3. Brincar com o código: alterar textos, cores e recompilar para ver as mudanças.

---

## Quer ajuda? Feedback

Se quiser que eu explique alguma parte do código em mais detalhe (por exemplo, como funciona a exportação, como os dados são salvos, ou como editar a tela X), diga qual arquivo ou qual ação você quer entender e eu explico passo a passo.

---

Boa sorte com o Finora! Se quiser, eu posso também atualizar o `README.md` principal com uma versão resumida deste conteúdo.
