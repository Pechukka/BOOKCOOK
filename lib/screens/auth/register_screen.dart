import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/logo_header.dart';
import '../../widgets/inputs/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _auth = AuthService.instance;

  bool _isLoading = false;
  String? _errorMessage;
  final Map<String, String?> _errors = {};

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool _validateAll() {
    final newErrors = <String, String?>{};
    newErrors['name'] = Validators.validateName(_nameController.text);
    newErrors['email'] = Validators.validateEmail(_emailController.text);
    newErrors['password'] = Validators.validatePassword(_passwordController.text);
    newErrors['confirm'] = Validators.validateConfirmPassword(
      _confirmController.text,
      _passwordController.text,
    );
    setState(() => _errors.addAll(newErrors));
    return newErrors.values.every((e) => e == null);
  }

  Future<void> _onRegister() async {
    if (!_validateAll()) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final error = await _auth.register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (error != null) {
      setState(() {
        _errorMessage = error;
        _isLoading = false;
      });
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const SizedBox(height: 24),
              const LogoHeader(subtitle: 'Create your account'),
              const SizedBox(height: 32),

              CustomTextField(
                label: 'Full name',
                hint: 'Your name',
                prefixIcon: Icons.person_outline_rounded,
                controller: _nameController,
              ),
              if (_errors['name'] != null) _ErrorText(_errors['name']!),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Email',
                hint: 'your@email.com',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              if (_errors['email'] != null) _ErrorText(_errors['email']!),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Password',
                hint: '••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                controller: _passwordController,
                isPassword: true,
              ),
              if (_errors['password'] != null) _ErrorText(_errors['password']!),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Confirm password',
                hint: '••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                controller: _confirmController,
                isPassword: true,
              ),
              if (_errors['confirm'] != null) _ErrorText(_errors['confirm']!),
              const SizedBox(height: 12),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red.shade600,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(
                      text: 'Create account',
                      onPressed: _onRegister,
                    ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  final String text;
  const _ErrorText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        style: TextStyle(color: Colors.red.shade600, fontSize: 12),
      ),
    );
  }
}