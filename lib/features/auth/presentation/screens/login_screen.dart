import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_pill_input.dart';
import '../widgets/auth_pill_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String? _usernameError;
  String? _passwordError;

  Future<void> login() async {
    setState(() {
      _usernameError = null;
      _passwordError = null;
    });

    final username = usernameController.text.trim();
    final password = passwordController.text;

    bool hasError = false;

    if (username.isEmpty) {
      setState(() {
        _usernameError = 'Username tidak boleh kosong';
      });
      hasError = true;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password tidak boleh kosong';
      });
      hasError = true;
    }

    if (hasError) {
      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .login(username, password);

    if (!mounted) return;

    if (success) {
      context.go('/');
    } else {
      final error = ref.read(authProvider).error;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Username atau Password salah'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),

      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/chevron-left-icon.svg",
                      width: 28,
                      height: 28,
                    ),
                  ),
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Masa Depan\nBertani, Hari Ini.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Plus Jakarta Sans",
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D1D1D),
                        height: 0.94,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Please SignIn to your account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Plus Jakarta Sans",
                        fontSize: 12,
                        color: Color(0xFF1D1D1D),
                      ),
                    ),

                    const SizedBox(height: 40),

                    AuthPillInput(
                      controller: usernameController,
                      hint: "Your Username",
                      enabled: !isLoading,
                    ),

                    if (_usernameError != null) ...[
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _usernameError!,
                          style: const TextStyle(
                            fontFamily: "Plus Jakarta Sans",
                            fontSize: 10,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    AuthPillInput(
                      controller: passwordController,
                      hint: "Your Password",
                      isPassword: true,
                      enabled: !isLoading,
                    ),

                    if (_passwordError != null) ...[
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _passwordError!,
                          style: const TextStyle(
                            fontFamily: "Plus Jakarta Sans",
                            fontSize: 10,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 8),

                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontFamily: "Plus Jakarta Sans",
                          fontSize: 10,
                          color: Color(0xFF1D1D1D),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    AuthPillButton(
                      text: "SignIn",
                      loading: isLoading,
                      onPressed: login,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
