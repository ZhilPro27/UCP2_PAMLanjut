import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../logic/bloc/auth/auth_bloc.dart';
import '../../../logic/bloc/auth/auth_event.dart';
import '../../../logic/bloc/auth/auth_state.dart';
import '../../core/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<ShadFormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onLogin() {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      context.read<AuthBloc>().add(LoginRequested(
            email: emailController.text,
            password: passwordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          if (state is AuthError) {
            ShadToaster.of(context).show(
              ShadToast.destructive(
                title: const Text('Gagal Login'),
                description: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ShadCard(
                width: 400,
                title: const Text('Login ke DriveEase', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                description: const Text('Masukkan email dan password untuk melanjutkan'),
                child: ShadForm(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),
                      ShadInputFormField(
                        id: 'email',
                        label: const Text('Email'),
                        placeholder: const Text('contoh@email.com'),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidators.email,
                      ),
                      const SizedBox(height: 16),
                      ShadInputFormField(
                        id: 'password',
                        label: const Text('Password'),
                        placeholder: const Text('Masukkan password'),
                        controller: passwordController,
                        obscureText: obscurePassword,
                        validator: (v) => AppValidators.password(v, minLength: 1), // Only required for login
                        trailing: ShadButton.ghost(
                          width: 24,
                          height: 24,
                          padding: EdgeInsets.zero,
                          child: Icon(
                            obscurePassword ? Icons.visibility_off : Icons.visibility,
                            size: 16,
                          ),
                          onPressed: () {
                            setState(() => obscurePassword = !obscurePassword);
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      ShadButton(
                        onPressed: isLoading ? null : onLogin,
                        child: isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Login'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Belum punya akun?'),
                          ShadButton.link(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                            child: const Text('Daftar di sini'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
