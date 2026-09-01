import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF4F46E5), // Vibrant Electric Indigo
      surfaceTint: Color(0xFF4F46E5),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFEEF2FF),
      onPrimaryContainer: Color(0xFF312E81),
      secondary: Color(0xFF0284C7), // Cyber Ocean Cyan
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFE0F2FE),
      onSecondaryContainer: Color(0xFF075985),
      tertiary: Color(0xFFD946EF), // Neon Fuchsia / Pink
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFDF4FF),
      onTertiaryContainer: Color(0xFF701A75),
      error: Color(0xFFDC2626),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF991B1B),
      surface: Color(0xFFF8FAFC), // Crisp Radiant Porcelain
      onSurface: Color(0xFF0F172A),
      onSurfaceVariant: Color(0xFF475569),
      outline: Color(0xFFCBD5E1),
      outlineVariant: Color(0xFFE2E8F0),
      shadow: Color(0x14000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF1E293B),
      inversePrimary: Color(0xFF818CF8),
      primaryFixed: Color(0xFF6366F1),
      onPrimaryFixed: Color(0xFFFFFFFF),
      primaryFixedDim: Color(0xFF4F46E5),
      onPrimaryFixedVariant: Color(0xFFFFFFFF),
      secondaryFixed: Color(0xFF0EA5E9),
      onSecondaryFixed: Color(0xFFFFFFFF),
      secondaryFixedDim: Color(0xFF0284C7),
      onSecondaryFixedVariant: Color(0xFFFFFFFF),
      tertiaryFixed: Color(0xFFEC4899),
      onTertiaryFixed: Color(0xFFFFFFFF),
      tertiaryFixedDim: Color(0xFFDB2777),
      onTertiaryFixedVariant: Color(0xFFFFFFFF),
      surfaceDim: Color(0xFFE2E8F0),
      surfaceBright: Color(0xFFFFFFFF),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFFFFFF),
      surfaceContainer: Color(0xFFF1F5F9),
      surfaceContainerHigh: Color(0xFFE2E8F0),
      surfaceContainerHighest: Color(0xFFCBD5E1),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF818CF8), // Luminous Electric Indigo
      surfaceTint: Color(0xFF818CF8),
      onPrimary: Color(0xFF0F172A),
      primaryContainer: Color(0xFF4F46E5),
      onPrimaryContainer: Color(0xFFEEF2FF),
      secondary: Color(0xFF38BDF8), // Radiant Cyber Cyan
      onSecondary: Color(0xFF082F49),
      secondaryContainer: Color(0xFF0369A1),
      onSecondaryContainer: Color(0xFFE0F2FE),
      tertiary: Color(0xFFF472B6), // Radiant Rose Pink
      onTertiary: Color(0xFF4C0519),
      tertiaryContainer: Color(0xFFBE185D),
      onTertiaryContainer: Color(0xFFFDF2F8),
      error: Color(0xFFF87171),
      onError: Color(0xFF450A0A),
      errorContainer: Color(0xFF991B1B),
      onErrorContainer: Color(0xFFFEE2E2),
      surface: Color(0xFF0B0F19), // Deep Cosmic Obsidian
      onSurface: Color(0xFFF8FAFC),
      onSurfaceVariant: Color(0xFF94A3B8),
      outline: Color(0xFF334155),
      outlineVariant: Color(0xFF1E293B),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFF1F5F9),
      inversePrimary: Color(0xFF4F46E5),
      primaryFixed: Color(0xFF6366F1),
      onPrimaryFixed: Color(0xFFFFFFFF),
      primaryFixedDim: Color(0xFF4338CA),
      onPrimaryFixedVariant: Color(0xFFFFFFFF),
      secondaryFixed: Color(0xFF0EA5E9),
      onSecondaryFixed: Color(0xFFFFFFFF),
      secondaryFixedDim: Color(0xFF0284C7),
      onSecondaryFixedVariant: Color(0xFFFFFFFF),
      tertiaryFixed: Color(0xFFEC4899),
      onTertiaryFixed: Color(0xFFFFFFFF),
      tertiaryFixedDim: Color(0xFFBE185D),
      onTertiaryFixedVariant: Color(0xFFFFFFFF),
      surfaceDim: Color(0xFF0B0F19),
      surfaceBright: Color(0xFF1E293B),
      surfaceContainerLowest: Color(0xFF060911),
      surfaceContainerLow: Color(0xFF101726), // Frosted Dark Slate Card
      surfaceContainer: Color(0xFF141E32), // Elevated Card
      surfaceContainerHigh: Color(0xFF1A2640),
      surfaceContainerHighest: Color(0xFF223254),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      fontFamily: 'Poppins',
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );
}
