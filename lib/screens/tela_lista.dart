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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: _series.isEmpty
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.playlist_add, size: 64, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Sua lista está vazia'),
                    Text('Adicione séries pela busca'),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _series.length,
                  itemBuilder: (context, index) {
                    final serie = _series[index];
                    return Card(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: serie.imagem == null
                              ? const SizedBox(
                                  width: 45,
                                  height: 64,
                                  child: Icon(Icons.tv),
                                )
                              : Image.network(
                                  serie.imagem!,
                                  width: 45,
                                  height: 64,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        title: Text(
                          serie.nome,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: serie.assistido
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text(
                          serie.assistido ? 'Assistido' : 'Quero assistir',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: serie.assistido,
                              onChanged: (valor) =>
                                  _marcarAssistido(serie, valor!),
                            ),
                            IconButton(
                              tooltip: 'Remover da lista',
                              onPressed: () => _excluir(serie),
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
