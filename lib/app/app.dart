import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme.dart';

class BookCookApp extends StatelessWidget {
  const BookCookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookCook',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      initialRoute: AppRoutes.splash,

      routes: AppRoutes.routes,
    );
  }
}