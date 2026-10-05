import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:series_firebase/model/serie.dart';

class TvMazeService {
  static const _baseUrl = 'https://api.tvmaze.com';
  static const _prazo = Duration(seconds: 15);
  static const _headers = {'Accept': 'application/json'};

  void _verificar(http.Response resposta) {
    if (resposta.statusCode == 404) {
      throw Exception('Série não encontrada');
    }
    if (resposta.statusCode != 200) {
      throw Exception('TvMaze: HTTP ${resposta.statusCode}');
    }
  }

  //Ocorre a busca por texto, retornando uma lista de séries
  Future<List<Serie>> buscarSeries(String texto) async {
    final uri = Uri.parse(
      '$_baseUrl/search/shows?q=${Uri.encodeComponent(texto)}',
    );
    final resposta = await http.get(uri, headers: _headers).timeout(_prazo);

    _verificar(resposta);

    final dados = jsonDecode(utf8.decode(resposta.bodyBytes)) as List;

    return dados
        .map((item) => Serie.fromJson(item['show'] as Map<String, dynamic>))
        .toList();
  }

  //Ocorre a busca por nome, retornando uma série
  Future<Serie> buscarPorNome(String nome) async {
    final uri = Uri.parse(
      '$_baseUrl/singlesearch/shows?q=${Uri.encodeComponent(nome)}',
    );
    final resposta = await http.get(uri, headers: _headers).timeout(_prazo);

    _verificar(resposta);

    final dados = jsonDecode(utf8.decode(resposta.bodyBytes));

    return Serie.fromJson(dados as Map<String, dynamic>);
  }

  //Ocorre a busca de detalhes por id, retornando uma série
  Future<Serie> detalhes(int id) async {
    final uri = Uri.parse('$_baseUrl/shows/$id');
    final resposta = await http.get(uri, headers: _headers).timeout(_prazo);

    _verificar(resposta);

    final dados = jsonDecode(utf8.decode(resposta.bodyBytes));

    return Serie.fromJson(dados as Map<String, dynamic>);
  }
}
