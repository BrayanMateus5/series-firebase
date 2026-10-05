import 'package:flutter/material.dart';
import 'package:series_firebase/model/serie.dart';
import 'package:series_firebase/service/tvmaze_service.dart';

class TelaBusca extends StatefulWidget {
  const TelaBusca({super.key});

  @override
  State<StatefulWidget> createState() {
    return TelaBuscaState();
  }
}

class TelaBuscaState extends State<TelaBusca> {
  final _service = TvMazeService();
  final _buscaController = TextEditingController();
  List<Serie> _series = [];

  bool _carregando = false;

  Future<void> _buscar() async {
    final texto = _buscaController.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      _carregando = true;
    });
    try {
      final series = await _service.buscarSeries(texto);
      setState(() {
        _series = series;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao buscar séries: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Séries')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (_carregando) const CircularProgressIndicator(),
                Expanded(
                  child: TextField(
                    controller: _buscaController,
                    decoration: const InputDecoration(
                      labelText: 'Nome da série',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.search), onPressed: _buscar),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _series.length,
              itemBuilder: (context, index) {
                final serie = _series[index];
                return ListTile(
                  leading: serie.imagem == null
                      ? null
                      : Image.network(serie.imagem!, width: 40),
                  title: Text(serie.nome),
                  subtitle: Text(serie.generos.join(', ')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
