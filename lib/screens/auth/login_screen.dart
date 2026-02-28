import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/logo_header.dart';
import '../../widgets/inputs/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // ── CONTROLLERS ──
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── MÉTODOS DE NAVEGACIÓN ──
  void _onLoginPressed() {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  void _onGoToRegister() {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  // ── BUILD ──
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 24,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const SizedBox(height: 40),

              
              const LogoHeader(
                subtitle: 'Your personal recipe book',
              ),

              const SizedBox(height: 48),

              
              CustomTextField(
                label: 'Email',
                hint: 'your@email.com',
                prefixIcon: Icons.mail_outline_rounded,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              
              CustomTextField(
                label: 'Password',
                hint: '••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                controller: _passwordController,
                isPassword: true,
              ),

              const SizedBox(height: 32),

              
              PrimaryButton(
                text: 'Log In',
                onPressed: _onLoginPressed,
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: _onGoToRegister,
                child: Text(
                  "Don't have an account?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}