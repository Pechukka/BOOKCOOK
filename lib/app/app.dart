import 'package:flutter/material.dart';
import 'theme.dart';
import 'routes.dart';

class BookCookApp extends StatelessWidget {
  const BookCookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookCook',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.getRoutes(),
    );
  }
}