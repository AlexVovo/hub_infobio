import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'artigos_page.dart'; // Importe sua página de artigos

class HomePage extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final IconData themeIcon;
  final String themeTooltip;

  HomePage({
    super.key,
    required this.onToggleTheme,
    required this.themeIcon,
    required this.themeTooltip,
  });

  final List<Map<String, dynamic>> projetos = [
    {
      'titulo': 'Análise Genômica',
      'descricao': 'Ferramentas e pipelines para análise de genomas e exomas.',
      'icone': FontAwesomeIcons.dna,
      'cor': Colors.teal,
    },
    {
      'titulo': 'Modelagem Molecular',
      'descricao': 'Simulações de estruturas proteicas e docking molecular.',
      'icone': Icons.biotech,
      'cor': Colors.deepPurple,
    },
    {
      'titulo': 'Bioinformática de RNA',
      'descricao': 'Análise de expressão gênica e RNA-Seq.',
      'icone': Icons.science,
      'cor': Colors.orange,
    },
    {
      'titulo': 'Machine Learning em Saúde',
      'descricao': 'Modelos preditivos aplicados à biologia e medicina.',
      'icone': Icons.memory,
      'cor': Colors.green,
    },
    {
      'titulo': 'Projetos ICI',
      'descricao':
          'Iniciativas e pesquisas do Instituto de Ciências Integradas.',
      'icone': Icons.build_circle,
      'cor': Colors.blueGrey,
    },
    {
      'titulo': 'Artigos',
      'descricao':
          'Publicações científicas e artigos relevantes em bioinformática.',
      'icone': Icons.book,
      'cor': Colors.lightBlue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsividade
    int crossAxisCount;
    if (screenWidth < 600) {
      crossAxisCount = 2; // Celulares
    } else if (screenWidth < 1000) {
      crossAxisCount = 3; // Tablets
    } else {
      crossAxisCount = 4; // Web
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🧬 Hub de Bioinformática',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: themeTooltip,
            icon: Icon(themeIcon),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: LayoutBuilder(
          key: ValueKey(screenWidth),
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: constraints.maxWidth < 400 ? 0.8 : 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: projetos.length,
                itemBuilder: (context, index) {
                  final projeto = projetos[index];
                  final theme = Theme.of(context);
                  final isDark = theme.brightness == Brightness.dark;

                  return GestureDetector(
                    onTap: () {
                      if (projeto['titulo'] == 'Artigos') {
                        // Navega diretamente para ArtigosPage
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 400,
                            ),
                            pageBuilder: (_, __, ___) => ArtigosPage(
                              cor: projeto['cor'],
                              icone: projeto['icone'],
                              titulo: projeto['titulo'],
                            ),
                            transitionsBuilder:
                                (context, animation, _, child) =>
                                    FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                          ),
                        );
                      } else {
                        // Mantém navegação para detalhes dos outros projetos
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 400,
                            ),
                            pageBuilder: (_, __, ___) =>
                                ProjetoDetalhesPage(projeto: projeto),
                            transitionsBuilder:
                                (context, animation, _, child) =>
                                    FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                          ),
                        );
                      }
                    },
                    child: Card(
                      color: isDark
                          ? projeto['cor'].withOpacity(0.25)
                          : projeto['cor'].withOpacity(0.1),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              projeto['icone'],
                              size: 50,
                              color: projeto['cor'],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              projeto['titulo'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth < 400 ? 14 : 16,
                                color: projeto['cor'],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              projeto['descricao'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenWidth < 400 ? 11 : 13,
                              ),
                            ),
                          ],
                        ),
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

// Página de detalhes para outros projetos
class ProjetoDetalhesPage extends StatelessWidget {
  final Map<String, dynamic> projeto;
  const ProjetoDetalhesPage({super.key, required this.projeto});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(projeto['titulo']),
        backgroundColor: projeto['cor'],
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
                  child: Icon(
                    projeto['icone'],
                    size: 80,
                    color: projeto['cor'],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  projeto['titulo'],
                  style: TextStyle(
                    fontSize: screenWidth < 400 ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: projeto['cor'],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  projeto['descricao'],
                  style: TextStyle(
                    fontSize: screenWidth < 400 ? 14 : 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: projeto['cor'],
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Funcionalidade em desenvolvimento 🔬'),
                        ),
                      );
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
