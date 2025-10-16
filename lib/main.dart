import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
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

// 🔹 Versão real da ArtigosPage com upload/download
class ArtigosPage extends StatefulWidget {
  final Color cor;
  final IconData icone;
  final String titulo;

  const ArtigosPage({
    super.key,
    required this.cor,
    required this.icone,
    required this.titulo,
  });

  @override
  State<ArtigosPage> createState() => _ArtigosPageState();
}

class _ArtigosPageState extends State<ArtigosPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<Reference> artigos = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadArtigos();
  }

  Future<void> _loadArtigos() async {
    setState(() => isLoading = true);
    final listResult = await storage.ref('artigos').listAll();
    setState(() {
      artigos = listResult.items;
      isLoading = false;
    });
  }

  Future<void> _uploadArquivo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;

      final uploadTask = storage.ref('artigos/$fileName').putFile(file);

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: StreamBuilder<TaskSnapshot>(
            stream: uploadTask.snapshotEvents,
            builder: (context, snapshot) {
              double progress = 0;
              if (snapshot.hasData) {
                progress =
                    snapshot.data!.bytesTransferred / snapshot.data!.totalBytes;
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Enviando $fileName'),
                  const SizedBox(height: 20),
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 10),
                  Text('${(progress * 100).toStringAsFixed(0)}%'),
                ],
              );
            },
          ),
        ),
      );

      await uploadTask;
      Navigator.pop(context); // fecha o diálogo
      _loadArtigos(); // recarrega a lista
    }
  }

  Future<void> _downloadArquivo(Reference ref) async {
    final url = await ref.getDownloadURL();
    // Aqui você pode abrir o PDF em visualizador ou baixar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('URL do PDF: $url')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: widget.cor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _uploadArquivo,
            tooltip: 'Enviar PDF',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: artigos.length,
              itemBuilder: (context, index) {
                final artigo = artigos[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.picture_as_pdf),
                    title: Text(artigo.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () => _downloadArquivo(artigo),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
