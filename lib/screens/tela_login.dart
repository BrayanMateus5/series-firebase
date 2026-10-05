import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:series_firebase/service/auth_service.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<StatefulWidget> createState() {
    return TelaLoginState();
  }
}

class TelaLoginState extends State<TelaLogin> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  Future<void> _entrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    if (email.isEmpty || senha.isEmpty) return;

    try {
      await _authService.entrar(email, senha);
      if (!mounted) return;
      context.go('/');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao entrar: $e')));
    }
  }

  Future<void> _cadastrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    if (email.isEmpty || senha.isEmpty) return;

    try {
      await _authService.cadastrar(email, senha);
      if (!mounted) return;
      context.go('/');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao cadastrar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  const Icon(Icons.live_tv, size: 72, color: Colors.deepPurple),
                  const SizedBox(height: 12),
                  const Text(
                    'Séries Firebase',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const Text('Busque séries e monte a sua lista'),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha (mínimo 6 caracteres)',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: _entrar,
                      icon: const Icon(Icons.login),
                      label: const Text('Entrar'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _cadastrar,
                    child: const Text('Ainda não tem conta? Criar conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
