import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppTheme {
  static ShadThemeData get theme {
    return ShadThemeData(
      brightness: Brightness.dark,
      colorScheme: const ShadSlateColorScheme.dark(
        background: Color(0xFF0f172a),
        primary: Color(0xFF1e3a5f),
        primaryForeground: Colors.white,
        destructive: Color(0xFFdc2626),
        destructiveForeground: Colors.white,
        muted: Color(0xFF1e293b),
        mutedForeground: Color(0xFF94a3b8),
        accent: Color(0xFF0d9488),
        accentForeground: Colors.white,
        border: Color(0xFF1e293b),
        input: Color(0xFF1e293b),
      ),
      textTheme: ShadTextTheme(
        h1: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        h2: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        h3: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        h4: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        p: TextStyle(fontSize: 16),
        small: TextStyle(fontSize: 14),
      ),
    );
  }
}
