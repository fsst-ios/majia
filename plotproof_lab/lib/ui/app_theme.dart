import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const ink = Color(0xFF11212D);
  static const amber = Color(0xFFF1B44C);
  static const mint = Color(0xFF56C6A9);
  static const coral = Color(0xFFE9775B);

  static ThemeData light() => _theme(Brightness.light);
  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: amber,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      colorScheme: scheme.copyWith(
        primary: isDark ? const Color(0xFFFFC865) : const Color(0xFF7A4D00),
        primaryContainer: isDark
            ? const Color(0xFFF1B44C)
            : const Color(0xFFFFE1A6),
        onPrimaryContainer: ink,
        secondary: isDark ? const Color(0xFF79D8BE) : const Color(0xFF006B58),
        secondaryContainer: isDark
            ? const Color(0xFF174A40)
            : const Color(0xFFC0F2E3),
        onSecondaryContainer: isDark ? Colors.white : const Color(0xFF00382E),
        surface: isDark ? const Color(0xFF11212D) : const Color(0xFFF7F8F3),
        error: isDark ? const Color(0xFFFFB4A7) : const Color(0xFF9A341F),
        errorContainer: isDark
            ? const Color(0xFF792D20)
            : const Color(0xFFFFDAD2),
        onErrorContainer: isDark ? Colors.white : const Color(0xFF3D0600),
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0A1720)
          : const Color(0xFFF1F3EE),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? const Color(0xFF142A38) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: isDark ? const Color(0xFF10232F) : Colors.white,
        indicatorColor: isDark
            ? const Color(0xFF5F461B)
            : const Color(0xFFFFE1A8),
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
