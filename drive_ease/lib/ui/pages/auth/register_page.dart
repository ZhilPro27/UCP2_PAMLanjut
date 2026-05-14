import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../logic/bloc/auth/auth_bloc.dart';
import '../../../logic/bloc/auth/auth_event.dart';
import '../../../logic/bloc/auth/auth_state.dart';
import '../../core/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<ShadFormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  bool obscurePassword = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void onRegister() {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      context.read<AuthBloc>().add(RegisterRequested(
            username: usernameController.text,
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
          if (state is Unauthenticated && ModalRoute.of(context)?.isCurrent == true) {
            // Note: If registration succeeds, the BLoC emits Unauthenticated.
            // We can show a toast and go to login.
            // Wait, we need to distinguish between initial Unauthenticated and successful register.
            // Actually, BLoC logs "Register Success" and emits Unauthenticated.
            // We can show toast here. It might trigger on startup, but we only navigate if on register page.
            ShadToaster.of(context).show(
              const ShadToast(
                title: Text('Registrasi Berhasil'),
                description: Text('Silakan login dengan akun baru Anda'),
              ),
            );
            Navigator.pushReplacementNamed(context, '/login');
          }
          if (state is AuthError) {
            ShadToaster.of(context).show(
              ShadToast.destructive(
                title: const Text('Gagal Registrasi'),
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
                title: const Text('Daftar Akun', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                description: const Text('Buat akun baru untuk mulai menggunakan DriveEase'),
                child: ShadForm(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),
                      ShadInputFormField(
                        id: 'username',
                        label: const Text('Username'),
                        placeholder: const Text('Masukkan username'),
                        controller: usernameController,
                        validator: (v) => AppValidators.requiredField(v, 'Username'),
                      ),
                      const SizedBox(height: 16),
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
                        placeholder: const Text('Minimal 3 karakter'),
                        controller: passwordController,
                        obscureText: obscurePassword,
                        validator: (v) => AppValidators.password(v),
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
                      const SizedBox(height: 16),
                      ShadInputFormField(
                        id: 'confirm_password',
                        label: const Text('Konfirmasi Password'),
                        placeholder: const Text('Ulangi password'),
                        controller: confirmPasswordController,
                        obscureText: obscureConfirm,
                        validator: (v) => AppValidators.confirmPassword(v, passwordController.text),
                        trailing: ShadButton.ghost(
                          width: 24,
                          height: 24,
                          padding: EdgeInsets.zero,
                          child: Icon(
                            obscureConfirm ? Icons.visibility_off : Icons.visibility,
                            size: 16,
                          ),
                          onPressed: () {
                            setState(() => obscureConfirm = !obscureConfirm);
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      ShadButton(
                        onPressed: isLoading ? null : onRegister,
                        child: isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Daftar'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Sudah punya akun?'),
                          ShadButton.link(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                            child: const Text('Login di sini'),
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
