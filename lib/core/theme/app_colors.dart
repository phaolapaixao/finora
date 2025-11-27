import 'package:flutter/material.dart';

class AppColors {
  // Cores do tema claro
  static const Color primaryLight = Color(0xFF6C63FF);
  static const Color secondaryLight = Color(0xFF00D4AA);
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color errorLight = Color(0xFFFF6B6B);
  static const Color successLight = Color(0xFF51CF66);
  static const Color warningLight = Color(0xFFFFD93D);

  static const Color textPrimaryLight = Color(0xFF2D3748);
  static const Color textSecondaryLight = Color(0xFF718096);

  // Cores do tema escuro
  static const Color primaryDark = Color(0xFF8B83FF);
  static const Color secondaryDark = Color(0xFF00F5C4);
  static const Color backgroundDark = Color(0xFF0F1419);
  static const Color surfaceDark = Color(0xFF1A202C);
  static const Color errorDark = Color(0xFFFF8787);
  static const Color successDark = Color(0xFF69DB7C);
  static const Color warningDark = Color(0xFFFFE066);

  static const Color textPrimaryDark = Color(0xFFE2E8F0);
  static const Color textSecondaryDark = Color(0xFFA0AEC0);

  // Cores das categorias
  static const List<Color> categoryColors = [
    Color(0xFFFF6B6B), // Vermelho
    Color(0xFF4ECDC4), // Turquesa
    Color(0xFFFFE66D), // Amarelo
    Color(0xFF95E1D3), // Menta
    Color(0xFFF38181), // Rosa
    Color(0xFFAA96DA), // Roxo
    Color(0xFFFCBF49), // Laranja
    Color(0xFF6A4C93), // Roxo escuro
    Color(0xFF06FFA5), // Verde néon
    Color(0xFFFF006E), // Rosa choque
    Color(0xFF8338EC), // Violeta
    Color(0xFF3A86FF), // Azul
  ];

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF51CF66), Color(0xFF37B24D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFEE5A52)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
