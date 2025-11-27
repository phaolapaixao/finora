import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ToggleTheme>(_onToggleTheme);
    on<SetThemeMode>(_onSetThemeMode);
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    if (state.themeMode == ThemeMode.light) {
      emit(state.copyWith(themeMode: ThemeMode.dark, isDark: true));
    } else {
      emit(state.copyWith(themeMode: ThemeMode.light, isDark: false));
    }
  }

  void _onSetThemeMode(SetThemeMode event, Emitter<ThemeState> emit) {
    emit(
      state.copyWith(
        themeMode: event.mode,
        isDark: event.mode == ThemeMode.dark,
      ),
    );
  }
}
