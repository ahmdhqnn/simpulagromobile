import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/responsive.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_pill_input.dart';
import '../widgets/auth_pill_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final bool sessionExpiredMessage;

  const LoginScreen({super.key, this.sessionExpiredMessage = false});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String? _usernameError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    if (widget.sessionExpiredMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Sesi Anda telah berakhir. Silakan login kembali.',
                style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
            ),
          );
        }
      });
    }
  }

  Future<void> login() async {
    setState(() {
      _usernameError = null;
      _passwordError = null;
    });

    final username = usernameController.text.trim();
    final password = passwordController.text;

    bool hasError = false;

    if (username.isEmpty) {
      setState(() => _usernameError = 'Username tidak boleh kosong');
      hasError = true;
    }

    if (password.isEmpty) {
      setState(() => _passwordError = 'Password tidak boleh kosong');
      hasError = true;
    }

    if (hasError) return;

    final success = await ref
        .read(authProvider.notifier)
        .login(username, password);

    if (!mounted) return;

    if (success) {
      context.go('/');
    } else {
      final error = ref.read(authProvider).error;
      showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.error_outline, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Text(
                'Gagal Login',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            error ?? 'Username atau Password salah',
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
              top: context.rh(0.012),
              left: context.rw(0.051),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: context.rw(0.148).clamp(48.0, 64.0),
                  height: context.rw(0.148).clamp(48.0, 64.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/chevron-left-icon.svg",
                      width: context.rw(0.072).clamp(22.0, 30.0),
                      height: context.rw(0.072).clamp(22.0, 30.0),
                    ),
                  ),
                ),
              ),
            ),

            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.rw(0.051)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Masa Depan\nBertani, Hari Ini.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Plus Jakarta Sans",
                        fontSize: context.sp(32),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1D1D1D),
                        height: 0.94,
                      ),
                    ),

                    SizedBox(height: context.rh(0.012)),

                    Text(
                      "Please SignIn to your account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Plus Jakarta Sans",
                        fontSize: context.sp(12),
                        color: const Color(0xFF1D1D1D),
                      ),
                    ),

                    SizedBox(height: context.rh(0.048)),

                    AuthPillInput(
                      controller: usernameController,
                      hint: "Your Username",
                      enabled: !isLoading,
                    ),

                    if (_usernameError != null) ...[
                      SizedBox(height: context.rh(0.005)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _usernameError!,
                          style: TextStyle(
                            fontFamily: "Plus Jakarta Sans",
                            fontSize: context.sp(10),
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: context.rh(0.015)),

                    AuthPillInput(
                      controller: passwordController,
                      hint: "Your Password",
                      isPassword: true,
                      enabled: !isLoading,
                    ),

                    if (_passwordError != null) ...[
                      SizedBox(height: context.rh(0.005)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _passwordError!,
                          style: TextStyle(
                            fontFamily: "Plus Jakarta Sans",
                            fontSize: context.sp(10),
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: context.rh(0.01)),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontFamily: "Plus Jakarta Sans",
                          fontSize: context.sp(10),
                          color: const Color(0xFF1D1D1D),
                        ),
                      ),
                    ),

                    SizedBox(height: context.rh(0.036)),

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
