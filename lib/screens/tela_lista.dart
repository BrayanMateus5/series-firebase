import 'package:flutter/material.dart';
import 'package:series_firebase/model/serie.dart';
import 'package:series_firebase/service/lista_service.dart';

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<StatefulWidget> createState() {
    return TelaListaState();
  }
}

class TelaListaState extends State<TelaLista> {
  final _service = ListaService();
  List<Serie> _series = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final series = await _service.listar();
    setState(() {
      _series = series;
    });
  }

  Future<void> _marcarAssistido(Serie serie, bool assistido) async {
    await _service.atualizar(serie.id, assistido);
    _carregar();
  }

  Future<void> _excluir(Serie serie) async {
    await _service.excluir(serie.id);
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha lista')),
      body: _series.isEmpty
          ? const Center(child: Text('Sua lista está vazia'))
          : ListView.builder(
              itemCount: _series.length,
              itemBuilder: (context, index) {
                final serie = _series[index];
                return ListTile(
                  leading: serie.imagem == null
                      ? null
                      : Image.network(serie.imagem!, width: 40),
                  title: Text(serie.nome),
                  subtitle: Text(
                    serie.assistido ? 'Assistido' : 'Quero assistir',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: serie.assistido,
                        onChanged: (valor) => _marcarAssistido(serie, valor!),
                      ),
                      IconButton(
                        onPressed: () => _excluir(serie),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
