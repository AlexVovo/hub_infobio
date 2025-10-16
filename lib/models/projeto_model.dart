import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Projeto {
  final String titulo;
  final String descricao;
  final int iconeCodePoint; // armazenamos o código do ícone
  final String iconeFontFamily; // "FontAwesomeSolid" ou "MaterialIcons"
  final Color cor;

  Projeto({
    required this.titulo,
    required this.descricao,
    required this.iconeCodePoint,
    required this.iconeFontFamily,
    required this.cor,
  });

  // Converte Firestore -> Projeto
  factory Projeto.fromMap(Map<String, dynamic> map) {
    return Projeto(
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      iconeCodePoint: map['iconeCodePoint'] ?? 0,
      iconeFontFamily: map['iconeFontFamily'] ?? 'MaterialIcons',
      cor: Color(map['cor'] ?? 0xFF000000),
    );
  }

  // Converte Projeto -> Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'iconeCodePoint': iconeCodePoint,
      'iconeFontFamily': iconeFontFamily,
      'cor': cor.value,
    };
  }

  // Retorna o IconData correto para exibir
  IconData get icone {
    if (iconeFontFamily == 'FontAwesomeSolid') {
      return IconDataSolid(iconeCodePoint);
    } else {
      return IconData(iconeCodePoint, fontFamily: iconeFontFamily);
    }
  }
}

// Helper para FontAwesome
IconData IconDataSolid(int codePoint) {
  return IconData(codePoint, fontFamily: 'FontAwesomeSolid');
}
