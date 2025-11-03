import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hub_infobio/views/artigos_page.dart';
import 'dart:io';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const BioHubApp());
}

class BioHubApp extends StatefulWidget {
  const BioHubApp({super.key});

  @override
  State<BioHubApp> createState() => _BioHubAppState();
}

class _BioHubAppState extends State<BioHubApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  IconData get _themeIcon {
    switch (_themeMode) {
      case ThemeMode.light:
        return Icons.dark_mode;
      case ThemeMode.dark:
        return Icons.brightness_auto;
      default:
        return Icons.light_mode;
    }
  }

  String get _themeTooltip {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Modo escuro';
      case ThemeMode.dark:
        return 'Modo automático';
      default:
        return 'Modo claro';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: MaterialApp(
        title: 'Hub de Bioinformática',
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: HomePage(
            key: ValueKey(_themeMode),
            onToggleTheme: _toggleTheme,
            themeIcon: _themeIcon,
            themeTooltip: _themeTooltip,
          ),
        ),
      ),
    );
  }
}

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
        },
        {
          'nome': 'Plataforma de Bioinformática Integrada',
          'descricao':
              'Desenvolvimento de uma plataforma integrada para análise e visualização de dados biológicos.',
          'icone': Icons.integration_instructions,
        },
        {
          'nome': 'IA em Diagnóstico Molecular',
          'descricao':
              'Aplicação de algoritmos de inteligência artificial no diagnóstico molecular e medicina personalizada.',
          'icone': Icons.psychology,
        },
        {
          'nome': 'Estudos de Microbioma Humano',
          'descricao':
              'Pesquisas sobre o papel do microbioma humano na saúde e nas doenças oncológicas.',
          'icone': Icons.biotech,
        },
        {
          'nome': 'Banco de Dados Oncológicos (RHC/TCGA)',
          'descricao':
              'Organização e integração de dados clínicos e genômicos em repositórios oncológicos.',
          'icone': Icons.storage,
        },
        {
          'nome': 'Teleonco Capacita',
          'descricao':
              'Capacitação profissional em oncologia via plataformas digitais e teleducação.',
          'icone': Icons.computer,
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
                // 🔹 Redirecionamento inteligente
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
                } else if (projeto['titulo'] == 'Projetos ICI') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProjetoDetalhesPage(projeto: projeto),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'A seção "${projeto['titulo']}" ainda está em desenvolvimento 🔬',
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

/// 🔹 Tela com subprojetos do ICI
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
      body: subprojetos.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  projeto['descricao'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
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
    );
  }
}

/// 🔹 Detalhes de cada subprojeto
class SubprojetoDetalhesPage extends StatelessWidget {
  final String titulo;
  final String descricao;
  final IconData icone;
  final Color cor;

  const SubprojetoDetalhesPage({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.icone,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
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
