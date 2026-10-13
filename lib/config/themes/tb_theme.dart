import 'package:flutter/material.dart';
import 'package:thingsboard_app/utils/transition/page_transitions.dart';

// ============================================================================
// Paleta Cúmulo Ingeniería
//   _cumuloBrand   #6F99CA  azul del logo (acentos)
//   _tbPrimaryColor #3F6EA6 azul del logo oscurecido para que el texto blanco
//                   sobre botones tenga contraste suficiente (5.3:1)
//   _tbTextColor   #1E3552  azul marino para títulos y barra superior
// ============================================================================
const int _tbPrimaryColorValue = 0xFF3F6EA6;
const Color _tbPrimaryColor = Color(_tbPrimaryColorValue);
const Color _tbSecondaryColor = Color(0xFF6F99CA);
const Color _cumuloBrand = Color(0xFF6F99CA);
const Color _tbDarkPrimaryColor = Color(0xFF8FB3DC);
Color get appPrimaryColor => _tbPrimaryColor;
const int _tbTextColorValue = 0xFF1E3552;
const Color _tbTextColor = Color(_tbTextColorValue);

Typography tbTypography = Typography.material2018();

const tbMatIndigo = MaterialColor(_tbPrimaryColorValue, <int, Color>{
  50: Color(0xFFECF0F6),
  100: Color(0xFFD5DFEB),
  200: Color(0xFFB2C5DB),
  300: Color(0xFF90ABCB),
  400: Color(0xFF698EBA),
  500: _tbPrimaryColor,
  600: Color(0xFF376192),
  700: Color(0xFF2F527C),
  800: Color(0xFF274467),
  900: Color(0xFF1E3550),
});

const tbDarkMatIndigo = MaterialColor(_tbPrimaryColorValue, <int, Color>{
  50: Color(0xFFECF0F6),
  100: Color(0xFFD5DFEB),
  200: Color(0xFFB2C5DB),
  300: Color(0xFF90ABCB),
  400: Color(0xFF698EBA),
  500: _tbDarkPrimaryColor,
  600: _tbSecondaryColor,
  700: Color(0xFF2F527C),
  800: _tbPrimaryColor,
  900: Color(0xFF1E3550),
});

final ThemeData theme = ThemeData(primarySwatch: tbMatIndigo);

ThemeData tbTheme = ThemeData(
  useMaterial3: false,
  primarySwatch: tbMatIndigo,
  colorScheme: theme.colorScheme.copyWith(
    primary: tbMatIndigo,
    secondary: _cumuloBrand,
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F7FA),
  textTheme: tbTypography.black,
  primaryTextTheme: tbTypography.black,
  typography: tbTypography,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: _tbTextColor,
    iconTheme: IconThemeData(color: _tbTextColor),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: _tbPrimaryColor,
    unselectedItemColor: Colors.black.withValues(alpha: .38),
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.iOS: FadeOpenPageTransitionsBuilder(),
      TargetPlatform.android: FadeOpenPageTransitionsBuilder(),
    },
  ),
);

final ThemeData darkTheme = ThemeData(
  primarySwatch: tbDarkMatIndigo,
  brightness: Brightness.dark,
);

ThemeData tbDarkTheme = ThemeData(
  primarySwatch: tbDarkMatIndigo,
  colorScheme: darkTheme.colorScheme.copyWith(secondary: _cumuloBrand),
  brightness: Brightness.dark,
);
