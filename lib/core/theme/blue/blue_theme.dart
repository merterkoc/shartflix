import 'package:flutter/material.dart';
import 'package:shartflix/core/theme/material_theme.dart';

class BlueMaterialTheme extends MaterialTheme {
  const BlueMaterialTheme({
    this.textTheme = const TextTheme(),
  });

  final TextTheme textTheme;

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff405f90),
      surfaceTint: Color(0xff405f90),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd6e3ff),
      onPrimaryContainer: Color(0xff274777),
      secondary: Color(0xff565f71),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffdae2f9),
      onSecondaryContainer: Color(0xff3e4759),
      tertiary: Color(0xff6f5575),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfff9d8fd),
      onTertiaryContainer: Color(0xff563e5c),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff191c20),
      onSurfaceVariant: Color(0xff44474e),
      outline: Color(0xff74777f),
      outlineVariant: Color(0xffc4c6d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3036),
      inversePrimary: Color(0xffaac7ff),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff001b3e),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff274777),
      secondaryFixed: Color(0xffdae2f9),
      onSecondaryFixed: Color(0xff131c2b),
      secondaryFixedDim: Color(0xffbec7dc),
      onSecondaryFixedVariant: Color(0xff3e4759),
      tertiaryFixed: Color(0xfff9d8fd),
      onTertiaryFixed: Color(0xff28132e),
      tertiaryFixedDim: Color(0xffdcbce0),
      onTertiaryFixedVariant: Color(0xff563e5c),
      surfaceDim: Color(0xffd9d9e0),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3fa),
      surfaceContainer: Color(0xffededf4),
      surfaceContainerHigh: Color(0xffe7e8ee),
      surfaceContainerHighest: Color(0xffe2e2e9),
    );
  }

  @override
  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff123665),
      surfaceTint: Color(0xff405f90),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4f6da0),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2d3647),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff646d80),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff452e4b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff7f6484),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff0f1116),
      onSurfaceVariant: Color(0xff33363e),
      outline: Color(0xff4f525a),
      outlineVariant: Color(0xff6a6d75),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3036),
      inversePrimary: Color(0xffaac7ff),
      primaryFixed: Color(0xff4f6da0),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff365586),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff646d80),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4c5567),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff7f6484),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff654c6b),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc5c6cd),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3fa),
      surfaceContainer: Color(0xffe7e8ee),
      surfaceContainerHigh: Color(0xffdcdce3),
      surfaceContainerHighest: Color(0xffd1d1d8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff022b5b),
      surfaceTint: Color(0xff405f90),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2a497a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff232c3d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff40495b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3a2440),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff59415f),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff292c33),
      outlineVariant: Color(0xff464951),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3036),
      inversePrimary: Color(0xffaac7ff),
      primaryFixed: Color(0xff2a497a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff0d3262),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff40495b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2a3344),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff59415f),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff412a47),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb8b8bf),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f0f7),
      surfaceContainer: Color(0xffe2e2e9),
      surfaceContainerHigh: Color(0xffd3d4db),
      surfaceContainerHighest: Color(0xffc5c6cd),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffaac7ff),
      surfaceTint: Color(0xffaac7ff),
      onPrimary: Color(0xff09305f),
      primaryContainer: Color(0xff274777),
      onPrimaryContainer: Color(0xffd6e3ff),
      secondary: Color(0xffbec7dc),
      onSecondary: Color(0xff283141),
      secondaryContainer: Color(0xff3e4759),
      onSecondaryContainer: Color(0xffdae2f9),
      tertiary: Color(0xffdcbce0),
      onTertiary: Color(0xff3f2845),
      tertiaryContainer: Color(0xff563e5c),
      onTertiaryContainer: Color(0xfff9d8fd),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff111318),
      onSurface: Color(0xffe2e2e9),
      onSurfaceVariant: Color(0xffc4c6d0),
      outline: Color(0xff8e9099),
      outlineVariant: Color(0xff44474e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff405f90),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff001b3e),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff274777),
      secondaryFixed: Color(0xffdae2f9),
      onSecondaryFixed: Color(0xff131c2b),
      secondaryFixedDim: Color(0xffbec7dc),
      onSecondaryFixedVariant: Color(0xff3e4759),
      tertiaryFixed: Color(0xfff9d8fd),
      onTertiaryFixed: Color(0xff28132e),
      tertiaryFixedDim: Color(0xffdcbce0),
      onTertiaryFixedVariant: Color(0xff563e5c),
      surfaceDim: Color(0xff111318),
      surfaceBright: Color(0xff37393e),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff282a2f),
      surfaceContainerHighest: Color(0xff33353a),
    );
  }

  @override
  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcdddff),
      surfaceTint: Color(0xffaac7ff),
      onPrimary: Color(0xff002550),
      primaryContainer: Color(0xff7491c6),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd3dcf2),
      onSecondary: Color(0xff1d2636),
      secondaryContainer: Color(0xff8891a5),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff3d2f7),
      onTertiary: Color(0xff331d39),
      tertiaryContainer: Color(0xffa487a9),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff111318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdadce5),
      outline: Color(0xffafb2bb),
      outlineVariant: Color(0xff8d9099),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff284878),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff00112b),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff123665),
      secondaryFixed: Color(0xffdae2f9),
      onSecondaryFixed: Color(0xff081120),
      secondaryFixedDim: Color(0xffbec7dc),
      onSecondaryFixedVariant: Color(0xff2d3647),
      tertiaryFixed: Color(0xfff9d8fd),
      onTertiaryFixed: Color(0xff1d0823),
      tertiaryFixedDim: Color(0xffdcbce0),
      onTertiaryFixedVariant: Color(0xff452e4b),
      surfaceDim: Color(0xff111318),
      surfaceBright: Color(0xff42444a),
      surfaceContainerLowest: Color(0xff06070c),
      surfaceContainerLow: Color(0xff1b1e22),
      surfaceContainer: Color(0xff26282d),
      surfaceContainerHigh: Color(0xff303238),
      surfaceContainerHighest: Color(0xff3c3e43),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffebf0ff),
      surfaceTint: Color(0xffaac7ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa5c3fc),
      onPrimaryContainer: Color(0xff000b20),
      secondary: Color(0xffebf0ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbac3d8),
      onSecondaryContainer: Color(0xff030b1a),
      tertiary: Color(0xffffe9ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffd8b8dc),
      onTertiaryContainer: Color(0xff16041d),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff111318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeeeff9),
      outlineVariant: Color(0xffc0c2cc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff284878),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff00112b),
      secondaryFixed: Color(0xffdae2f9),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbec7dc),
      onSecondaryFixedVariant: Color(0xff081120),
      tertiaryFixed: Color(0xfff9d8fd),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffdcbce0),
      onTertiaryFixedVariant: Color(0xff1d0823),
      surfaceDim: Color(0xff111318),
      surfaceBright: Color(0xff4e5056),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1d2024),
      surfaceContainer: Color(0xff2e3036),
      surfaceContainerHigh: Color(0xff393b41),
      surfaceContainerHighest: Color(0xff45474c),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.copyWith(
      bodyLarge: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      bodyMedium: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      bodySmall: textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurface,
      ),
      labelLarge: textTheme.labelLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      labelMedium: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      labelSmall: textTheme.labelSmall?.copyWith(
        color: colorScheme.onSurface,
      ),
      displayLarge: textTheme.displayLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      displayMedium: textTheme.displayMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      displaySmall: textTheme.displaySmall?.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineLarge: textTheme.headlineLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineMedium: textTheme.headlineMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineSmall: textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface,
      ),
      titleLarge: textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      titleMedium: textTheme.titleMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      titleSmall: textTheme.titleSmall?.copyWith(
        color: colorScheme.onSurface,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
      ),
    ),
    primaryTextTheme: textTheme,
    cardTheme: CardThemeData(
      surfaceTintColor: colorScheme.onSecondaryContainer,
      color: colorScheme.inverseSurface,
      elevation: 0,
      shadowColor: colorScheme.shadow,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });

  final Color seed;
  final Color value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
