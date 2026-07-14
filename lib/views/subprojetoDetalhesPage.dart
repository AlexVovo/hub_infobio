
import 'package:flutter/material.dart';

class SubprojetoDetalhesPage extends StatelessWidget {
  final String titulo;
  final String descricao;
  final String imagem;
  final IconData icone;
  final Color cor;

  const SubprojetoDetalhesPage({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.imagem,
    required this.icone,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: cor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icone, size: 80, color: cor),
            const SizedBox(height: 20),
            if (imagem.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagem,
                  fit: BoxFit.cover,
                  width: screenWidth * 0.8,
                ),
              ),
            const SizedBox(height: 20),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              descricao,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
