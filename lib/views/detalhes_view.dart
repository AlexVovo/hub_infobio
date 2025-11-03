import 'package:flutter/material.dart';
import 'package:hub_infobio/views/home_view.dart';

class ProjetoDetalhesPage extends StatelessWidget {
  final Map<String, dynamic> projeto;
  const ProjetoDetalhesPage({super.key, required this.projeto});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> subprojetos =
        (projeto['subprojetos'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(projeto['titulo']),
        backgroundColor: projeto['cor'],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: subprojetos.isEmpty
            ? Center(
                child: Text(
                  projeto['descricao'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: subprojetos.length,
                itemBuilder: (context, index) {
                  final sub = subprojetos[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(sub['icone'], color: projeto['cor']),
                      title: Text(sub['nome']),
                      subtitle: Text(sub['descricao']),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubprojetoDetalhesPage(
                              titulo: sub['nome'],
                              descricao: sub['descricao'],
                              imagem: sub['imagem'],
                              icone: sub['icone'],
                              cor: projeto['cor'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
