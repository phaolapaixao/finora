import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/database_helper.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'presentation/bloc/category/category_bloc.dart';
import 'presentation/bloc/category/category_event.dart';
import 'presentation/bloc/filter/filter_bloc.dart';
import 'presentation/bloc/theme/theme_bloc.dart';
import 'presentation/bloc/theme/theme_state.dart';
import 'presentation/bloc/transaction/transaction_bloc.dart';
import 'presentation/bloc/transaction/transaction_event.dart';
import 'presentation/pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necessário para chamadas assíncronas no main

  // Inicializa a formatação de datas para o locale pt_BR
  await initializeDateFormatting('pt_BR', null);

  runApp(const FinoraApp());
}

class FinoraApp extends StatelessWidget {
  const FinoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseHelper = DatabaseHelper.instance;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) =>
              TransactionRepositoryImpl(databaseHelper: databaseHelper),
        ),
        RepositoryProvider(
          create: (context) =>
              CategoryRepositoryImpl(databaseHelper: databaseHelper),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ThemeBloc()),
          BlocProvider(
            create: (context) => TransactionBloc(
              repository: context.read<TransactionRepositoryImpl>(),
            )..add(LoadTransactions()),
          ),
          BlocProvider(
            create: (context) =>
                CategoryBloc(repository: context.read<CategoryRepositoryImpl>())
                  ..add(LoadCategories()),
          ),
          BlocProvider(create: (context) => FilterBloc()),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              title: 'Finora',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: themeState.themeMode,
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}
