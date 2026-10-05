class Serie {
  final int id;
  final String nome;
  final String? imagem;
  final double? nota;
  final List<String> generos;
  final String resumo;
  final bool assistido;

  const Serie({
    required this.id,
    required this.nome,
    this.imagem,
    this.nota,
    this.generos = const [],
    this.resumo = '',
    this.assistido = false,
  });

  //chega da API TVmaze
  factory Serie.fromJson(Map<String, dynamic> json) {
    final imagem = json['image'] as Map<String, dynamic>?;
    final nota = json['rating']['average'] as num?;
    final resumo = json['summary'] as String? ?? '';

    return Serie(
      id: json['id'] as int,
      nome: json['name'] as String,
      imagem: imagem?['medium'] as String?,
      nota: nota?.toDouble(),
      generos: List<String>.from(json['genres'] as List),
      //removendo as tags HTML do resumo
      resumo: resumo.replaceAll(RegExp(r'<[^>]*>'), ''),
    );
  }

  //chega do banco de dados
  factory Serie.fromMap(Map<String, dynamic> map) {
    return Serie(
      id: map['id'] as int,
      nome: map['nome'] as String,
      imagem: map['imagem'] as String?,
      nota: (map['nota'] as num?)?.toDouble(),
      generos: List<String>.from(map['generos'] as List),
      assistido: map['assistido'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'imagem': imagem,
      'nota': nota,
      'generos': generos,
      'assistido': assistido,
    };
  }
}
