import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:series_firebase/model/serie.dart';
import 'package:series_firebase/service/auth_service.dart';

class ListaService {
  final _db = FirebaseFirestore.instance;
  final _authService = AuthService();

  // Cada usuário tem sua lista...
  CollectionReference<Map<String, dynamic>> _lista() {
    final uid = _authService.usuario!.uid;
    return _db.collection('usuarios').doc(uid).collection('lista');
  }

  //O id da série vira o id do documento..
  Future<void> adicionar(Serie serie) async {
    await _lista().doc(serie.id.toString()).set(serie.toMap());
  }

  Future<List<Serie>> listar() async {
    final resultado = await _lista().orderBy('nome').get();
    return resultado.docs.map((doc) => Serie.fromMap(doc.data())).toList();
  }

  Future<void> atualizar(int id, bool assistido) async {
    await _lista().doc(id.toString()).update({'assistido': assistido});
  }

  Future<void> excluir(int id) async {
    await _lista().doc(id.toString()).delete();
  }
}
