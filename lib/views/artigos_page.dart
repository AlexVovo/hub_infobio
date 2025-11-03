import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

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
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Reference> artigos = [];
  List<String> _links = [];
  bool isLoading = false;

  final TextEditingController _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadArtigos();
    _loadLinks();
  }

  /// Carrega PDFs do Firebase Storage
  Future<void> _loadArtigos() async {
    setState(() => isLoading = true);
    final listResult = await storage.ref('artigos').listAll();
    setState(() {
      artigos = listResult.items;
      isLoading = false;
    });
  }

  /// Carrega links do Firestore
  Future<void> _loadLinks() async {
    final snapshot = await firestore.collection('artigos_links').get();
    setState(() {
      _links = snapshot.docs.map((doc) => doc['url'] as String).toList();
    });
  }

  /// Upload de PDF
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
                ],
              );
            },
          ),
        ),
      );

      await uploadTask;
      Navigator.pop(context);
      _loadArtigos();
    }
  }

  /// Mostra link do PDF
  Future<void> _downloadArquivo(Reference ref) async {
    final url = await ref.getDownloadURL();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Link para download: $url')));
  }

  /// Adiciona link ao Firestore
  Future<void> _adicionarLink() async {
    final link = _linkController.text.trim();
    if (link.isEmpty || Uri.tryParse(link)?.hasAbsolutePath != true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Digite um link válido.')));
      return;
    }

    // Salva no Firestore
    await firestore.collection('artigos_links').add({'url': link});

    setState(() {
      _links.add(link);
      _linkController.clear();
    });
  }

  /// Abre link externo
  Future<void> _abrirLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link.')),
      );
    }
  }

  /// Remove link do Firestore
  Future<void> _removerLink(String link) async {
    final snapshot = await firestore
        .collection('artigos_links')
        .where('url', isEqualTo: link)
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    setState(() {
      _links.remove(link);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo), backgroundColor: widget.cor),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _uploadArquivo,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload de Artigo (PDF)'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _linkController,
                    decoration: const InputDecoration(
                      labelText: 'Adicionar link de artigo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _adicionarLink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Icon(Icons.add_link),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView(
                      children: [
                        // PDFs
                        ...artigos.map(
                          (artigo) => Card(
                            child: ListTile(
                              leading: const Icon(Icons.picture_as_pdf),
                              title: Text(artigo.name),
                              trailing: IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () => _downloadArquivo(artigo),
                              ),
                            ),
                          ),
                        ),
                        // Links
                        ..._links.map(
                          (link) => Card(
                            child: ListTile(
                              leading: const Icon(Icons.link),
                              title: Text(
                                link,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.open_in_new),
                                    onPressed: () => _abrirLink(link),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _removerLink(link),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
