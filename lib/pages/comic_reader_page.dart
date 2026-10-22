import 'package:flutter/material.dart';
import 'package:flureadium/flureadium.dart';
import 'package:flutter_tts_improved/flutter_tts_improved.dart';

class ComicReaderPage extends StatefulWidget {
  final String comicPath; // Caminho para o PDF ou CBZ

  const ComicReaderPage({super.key, required this.comicPath});

  @override
  State<ComicReaderPage> createState() => _ComicReaderPageState();
}

class _ComicReaderPageState extends State<ComicReaderPage> {
  FlutterTtsImproved _tts = FlutterTtsImproved();
  String _currentWord = "";
  String _pageText = "O texto da pagina sera extraido aqui (via OCR).";

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    _tts.setProgressHandler((String fullPhrase, int wordOffset, int endOfWordOffset, String currentWord) {
      setState(() {
        _currentWord = currentWord;
      });
    });
  }

  Future<void> _readAloud() async {
    await _tts.setLanguage("pt-BR");
    await _tts.setSpeechRate(0.5); // Mais lento para criancas
    await _tts.speak(_pageText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leitor Gibi SOTA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: _readAloud,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Aqui sera renderizado o PDF/CBZ via flureadium.

'
                'Texto extraido: $_pageText',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (_currentWord.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green.shade100,
              child: Text(
                'A ler: $_currentWord',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }
}
