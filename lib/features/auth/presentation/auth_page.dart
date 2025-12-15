import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/auth_controller.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    ref.listen(authControllerProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Quest Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Switch(
                  value: _isLogin,
                  onChanged: (value) => setState(() => _isLogin = value),
                ),
                Text(_isLogin ? 'Login' : 'Register'),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authState.isLoading
                    ? null
                    : () async {
                        if (_isLogin) {
                          await ref
                              .read(authControllerProvider.notifier)
                              .signIn(_emailController.text, _passwordController.text);
                        } else {
                          await ref
                              .read(authControllerProvider.notifier)
                              .register(_emailController.text, _passwordController.text);
                        }
                        if (mounted) context.go('/onboarding');
                      },
                child: Text(_isLogin ? 'Login' : 'Register'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).signInGuest();
                if (mounted) context.go('/onboarding');
              },
              child: const Text('Continue as guest'),
            )
          ],
        ),
      ),
    );
  }
}
