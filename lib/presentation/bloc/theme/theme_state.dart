import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final bool isDark;

  const ThemeState({required this.themeMode, required this.isDark});

  factory ThemeState.initial() {
    return const ThemeState(themeMode: ThemeMode.system, isDark: false);
  }

  ThemeState copyWith({ThemeMode? themeMode, bool? isDark}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  List<Object?> get props => [themeMode, isDark];
}
