import 'package:flutter/material.dart';
import '../models/projeto_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProjetoController {
  // Aqui futuramente você pode integrar com Firebase
  final List<Projeto> _projetos = [
    Projeto(
      titulo: 'Modelagem Molecular',
      descricao: 'Simulações de estruturas proteicas e docking molecular.',
      icone: Icons.biotech,
      cor: Colors.deepPurple,
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
  ];

  List<Projeto> get projetos => _projetos;
}
