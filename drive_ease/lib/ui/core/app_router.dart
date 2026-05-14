import 'package:flutter/material.dart';

// Placeholder imports for pages. We will create these pages next.
import '../pages/auth/splash_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/home/home_page.dart';
import '../pages/katalog/katalog_form_page.dart';
import '../pages/katalog/katalog_detail_page.dart';
import '../pages/kategori/kategori_form_page.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/katalog/form':
        final args = settings.arguments as Map<String, dynamic>?;
        final id = args?['id'] as int?;
        return MaterialPageRoute(builder: (_) => KatalogFormPage(katalogId: id));
      case '/katalog/detail':
        final args = settings.arguments as Map<String, dynamic>?;
        final id = args?['id'] as int;
        return MaterialPageRoute(builder: (_) => KatalogDetailPage(katalogId: id));
      case '/kategori/form':
        final args = settings.arguments as Map<String, dynamic>?;
        final id = args?['id'] as int?;
        return MaterialPageRoute(builder: (_) => KategoriFormPage(kategoriId: id));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
