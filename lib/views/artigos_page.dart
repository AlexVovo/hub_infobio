import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
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
                ],
              );
            },
          ),
        ),
      );

      await uploadTask;
      Navigator.pop(context); // fecha o diálogo
      _loadArtigos();
    }
  }

  Future<void> _downloadArquivo(Reference ref) async {
    final url = await ref.getDownloadURL();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Link para download: $url')));
    // Aqui você pode abrir o PDF ou salvar no dispositivo usando packages como `open_file` ou `url_launcher`
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
              label: const Text('Upload de Artigo'),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: artigos.length,
                      itemBuilder: (context, index) {
                        final artigo = artigos[index];
                        return Card(
                          child: ListTile(
                            title: Text(artigo.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () => _downloadArquivo(artigo),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
