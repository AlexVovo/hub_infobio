import 'package:flutter/material.dart';
import 'package:hub_infobio/views/artigos_page.dart';
import '../models/projeto_model.dart';

class DetalhesView extends StatelessWidget {
  final Projeto projeto;
  const DetalhesView({super.key, required this.projeto});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(projeto.titulo),
        backgroundColor: projeto.cor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(projeto.icone, size: 80, color: projeto.cor),
                ),
                const SizedBox(height: 20),
                Text(
                  projeto.titulo,
                  style: TextStyle(
                    fontSize: screenWidth < 400 ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: projeto.cor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  projeto.descricao,
                  style: TextStyle(
                    fontSize: screenWidth < 400 ? 14 : 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: projeto.cor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (projeto.titulo == 'Artigos') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ArtigosPage(
                              cor: projeto.cor,
                              icone: projeto.icone,
                              titulo: projeto.titulo,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Funcionalidade em desenvolvimento 🔬',
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.link),
                    label: const Text('Ver mais detalhes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
