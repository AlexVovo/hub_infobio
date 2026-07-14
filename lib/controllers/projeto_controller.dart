import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Projeto {
  final String titulo;
  final String descricao;
  final IconData icone;
  final Color cor;

  Projeto({
    required this.titulo,
    required this.descricao,
    required this.icone,
    required this.cor,
  });

  // 🔹 Converte Projeto para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'icone': icone.codePoint, // salvando código do ícone
      'iconeFont': icone.fontFamily,
      'cor': cor.value,
    };
  }

  // 🔹 Constrói Projeto a partir de Map do Firestore
  factory Projeto.fromMap(Map<String, dynamic> map) {
    return Projeto(
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      icone: IconData(
        map['icone'] ?? 0xe900,
        fontFamily: map['iconeFont'] ?? 'FontAwesomeSolid',
      ),
      cor: Color(map['cor'] ?? 0xFF000000),
    );
  }
}

class ProjetoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Lista local de fallback
  final List<Projeto> _projetosLocais = [
    Projeto(
      titulo: 'Análise Genômica',
      descricao: 'Ferramentas e pipelines para análise de genomas e exomas.',
      icone: FontAwesomeIcons.dna,
      cor: Colors.teal,
    ),
    Projeto(
      titulo: 'Modelagem Molecular',
      descricao: 'Simulações de estruturas proteicas e docking molecular.',
      icone: Icons.biotech,
      cor: Colors.deepPurple,
    ),
    Projeto(
      titulo: 'Bioinformática de RNA',
      descricao: 'Análise de expressão gênica e RNA-Seq.',
      icone: Icons.science,
      cor: Colors.orange,
    ),
    Projeto(
      titulo: 'Machine Learning em Saúde',
      descricao: 'Modelos preditivos aplicados à biologia e medicina.',
      icone: Icons.memory,
      cor: Colors.green,
    ),
    Projeto(
      titulo: 'Projetos ICI',
      descricao: 'Iniciativas e pesquisas do Instituto de Ciências Integradas.',
      icone: FontAwesomeIcons.flask,
      cor: Colors.blueAccent,
    ),
    Projeto(
      titulo: 'Artigos',
      descricao:
          'Publicações científicas e artigos relevantes em bioinformática.',
      icone: FontAwesomeIcons.bookOpen,
      cor: Colors.amber,
    ),
  ];

  /// 🔹 Retorna os projetos do Firestore. Se não houver, retorna os locais.
  Future<List<Projeto>> getProjetos() async {
    try {
      final snapshot = await _firestore.collection('projetos').get();

      if (snapshot.docs.isEmpty) {
        // Se não houver projetos, salva os locais no Firestore
        for (var projeto in _projetosLocais) {
          await adicionarProjeto(projeto);
        }
        return _projetosLocais;
      }

      return snapshot.docs.map((doc) => Projeto.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint('Erro ao buscar projetos: $e');
      return _projetosLocais; // fallback local
    }
  }

  /// 🔹 Adiciona um projeto no Firestore
  Future<void> adicionarProjeto(Projeto projeto) async {
    try {
      await _firestore.collection('projetos').add(projeto.toMap());
    } catch (e) {
      debugPrint('Erro ao adicionar projeto: $e');
    }
  }

  /// 🔹 Remove um projeto pelo título
  Future<void> removerProjeto(String titulo) async {
    try {
      final snapshot = await _firestore
          .collection('projetos')
          .where('titulo', isEqualTo: titulo)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      debugPrint('Erro ao remover projeto: $e');
    }
  }
}
