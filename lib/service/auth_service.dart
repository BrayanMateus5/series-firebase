import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  //Usuário logado atualmente
  User? get usuario => _auth.currentUser;

  Future<void> entrar(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> cadastrar(String email, String senha) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> sair() async {
    await _auth.signOut();
  }
}
