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
      appBar: AppBar(title: const Text('Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha (mínimo 6 caracteres)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _entrar,
                child: const Text('Entrar'),
              ),
            ),
            TextButton(onPressed: _cadastrar, child: const Text('Criar conta')),
          ],
        ),
      ),
    );
  }
}
