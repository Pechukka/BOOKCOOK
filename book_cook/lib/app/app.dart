import 'package:flutter/material.dart';
import 'theme.dart';
import 'routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookCook',
      debugShowCheckedModeBanner: false,

      // Tema global
      theme: AppTheme.lightTheme,

      // Ruta inicial
      initialRoute: AppRoutes.login,

      // Mapa de rutas
      routes: AppRoutes.routes,
    );
  }
}
