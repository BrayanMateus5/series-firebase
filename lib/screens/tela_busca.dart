import 'package:flutter/material.dart';
import 'package:series_firebase/model/serie.dart';
import 'package:series_firebase/service/tvmaze_service.dart';
import 'package:go_router/go_router.dart';
import 'package:series_firebase/service/auth_service.dart';
import 'package:series_firebase/service/lista_service.dart';

class TelaBusca extends StatefulWidget {
  const TelaBusca({super.key});

  @override
  State<StatefulWidget> createState() {
    return TelaBuscaState();
  }
}

class TelaBuscaState extends State<TelaBusca> {
  final _service = TvMazeService();
  final _listaService = ListaService();
  final _authService = AuthService();
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

  Future<void> _adicionar(Serie serie) async {
    await _listaService.adicionar(serie);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${serie.nome} adicionada à sua lista')),
    );
  }

  Future<void> _sair() async {
    await _authService.sair();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Séries'),
        actions: [
          IconButton(
            tooltip: 'Minha lista',
            onPressed: () => context.push('/lista'),
            icon: const Icon(Icons.list),
          ),
          IconButton(
            tooltip: 'Sair',
            onPressed: _sair,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _buscaController,
                        onSubmitted: (texto) => _buscar(),
                        decoration: InputDecoration(
                          labelText: 'Nome da série',
                          hintText: 'Ex.: Friends',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _carregando
                        ? const CircularProgressIndicator()
                        : IconButton.filled(
                            onPressed: _buscar,
                            icon: const Icon(Icons.search),
                          ),
                  ],
                ),
              ),
              Expanded(
                child: _series.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.movie_filter,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text('Busque uma série pelo nome'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    serie.nota == null ? '-' : '${serie.nota}',
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      serie.generos.join(', '),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton.filledTonal(
                                tooltip: 'Adicionar à minha lista',
                                onPressed: () => _adicionar(serie),
                                icon: const Icon(Icons.add),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
