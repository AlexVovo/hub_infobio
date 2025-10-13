import 'package:flutter/material.dart';
import '../controllers/projeto_controller.dart';
import '../models/projeto_model.dart';
import 'detalhes_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjetoController controller = ProjetoController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🧬 Hub de Bioinformática',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.projetos.length,
          itemBuilder: (context, index) {
            Projeto projeto = controller.projetos[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetalhesView(projeto: projeto),
                  ),
                );
              },
              child: Card(
                color: projeto.cor.withOpacity(0.1),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(projeto.icone, size: 50, color: projeto.cor),
                      const SizedBox(height: 12),
                      Text(
                        projeto.titulo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: projeto.cor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        projeto.descricao,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
