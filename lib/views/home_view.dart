import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'artigos_page.dart';

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
      'subprojetos': [
        {
          'nome': 'Genômica de Tumores Pediátricos',
          'descricao':
              'Estudo genético de tumores pediátricos para identificar biomarcadores e padrões mutacionais.',
          'icone': Icons.child_care,
          'imagem': 'assets/images/tumores_pediatricos.jpeg',
        },
        {
          'nome': 'Plataforma de Bioinformática Integrada',
          'descricao':
              'Desenvolvimento de um ecossistema integrado para análise e visualização de dados biológicos.',
          'icone': Icons.integration_instructions,
          'imagem': 'assets/images/plataforma_bioinfo.jpg',
        },
        {
          'nome': 'IA em Diagnóstico Molecular',
          'descricao':
              'Aplicação de algoritmos de IA no diagnóstico molecular e predição de terapias personalizadas.',
          'icone': Icons.psychology,
          'imagem': 'assets/images/ia_diagnostico.jpg',
        },
        {
          'nome': 'Estudos de Microbioma Humano',
          'descricao':
              'Pesquisas sobre o papel do microbioma humano na saúde e nas doenças oncológicas.',
          'icone': Icons.biotech,
          'imagem': 'assets/images/microbioma.jpg',
        },
        {
          'nome': 'Banco de Dados Oncológicos (RHC/TCGA)',
          'descricao':
              'Organização e integração de dados clínicos e genômicos em repositórios oncológicos.',
          'icone': Icons.storage,
          'imagem': 'assets/images/banco_dados.jpg',
        },
        {
          'nome': 'Teleonco Capacita',
          'descricao':
              'Capacitação profissional em oncologia via plataformas digitais e teleducação.',
          'icone': Icons.computer,
          'imagem': 'assets/images/teleonco.jpg',
        },
      ],
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

    int crossAxisCount;
    if (screenWidth < 600) {
      crossAxisCount = 2;
    } else if (screenWidth < 1000) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 4;
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: screenWidth < 400 ? 0.8 : 1,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArtigosPage(
                        cor: projeto['cor'],
                        icone: projeto['icone'],
                        titulo: projeto['titulo'],
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProjetoDetalhesPage(projeto: projeto),
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
                      Icon(projeto['icone'], size: 50, color: projeto['cor']),
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
                        style: TextStyle(fontSize: screenWidth < 400 ? 11 : 13),
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

/// 🔹 Tela de detalhes dos projetos principais
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

/// 🔹 Tela detalhada de cada subprojeto
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
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
