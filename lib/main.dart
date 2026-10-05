import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:series_firebase/screens/tela_busca.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const TelaBusca()),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Séries',
      routerConfig: router,
    );
  }
}
