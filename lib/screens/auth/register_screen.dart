import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/logo_header.dart';
import '../../widgets/inputs/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  // ── CONTROLLERS ──
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── METODOS DE NAVEGACION ──
  void _onRegisterPressed() {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  void _onGoToLogin() {
    Navigator.pop(context);
  }

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

              const SizedBox(height: 24),

              const LogoHeader(
                subtitle: 'Create your account',
              ),

              const SizedBox(height: 8),

              Text(
                'Start organizing your recipes',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 36),

              CustomTextField(
                label: 'Name',
                hint: 'Your name',
                prefixIcon: Icons.person_outline_rounded,
                controller: _nameController,
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 20),

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

              const SizedBox(height: 20),

              CustomTextField(
                label: 'Confirm password',
                hint: '••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                controller: _confirmPasswordController,
                isPassword: true,
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                text: 'Create account',
                onPressed: _onRegisterPressed,
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: _onGoToLogin,
                child: Text(
                  'Already have an account?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor:
                        Theme.of(context).textTheme.bodyMedium?.color,
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