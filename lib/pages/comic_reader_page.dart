import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_tts_improved/flutter_tts_improved.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ocr_service.dart';
import '../services/voice_manager.dart';
import '../services/audio_exporter.dart';

class ComicReaderPage extends StatefulWidget {
  final String? comicPath;
  const ComicReaderPage({super.key, this.comicPath});
  @override
  State<ComicReaderPage> createState() => _ComicReaderPageState();
}

class _ComicReaderPageState extends State<ComicReaderPage> {
  final FlutterTtsImproved _tts = FlutterTtsImproved();
  final OcrService _ocr = OcrService();
  final ImagePicker _picker = ImagePicker();

  List<BubbleData> _bubbles = [];
  bool _loading = false, _reading = false, _fallback = true;
  int _idx = -1;
  Uint8List? _img;

  @override
  void initState() { super.initState(); _initTts(); }

  void _initTts() {
    _tts.setCompletionHandler(() {
      if (_reading && _idx < _bubbles.length - 1) { _next(); }
      else { setState(() { _reading = false; _idx = -1; }); }
    });
  }

  Future<void> _pick() async {
    final p = await _picker.pickImage(source: ImageSource.gallery);
    if (p == null) return;
    await _process(await p.readAsBytes());
  }

  Future<void> _process(Uint8List b) async {
    setState(() { _loading = true; _img = b; _bubbles = []; });
    final r = await _ocr.extractBubbles(b);
    setState(() { _bubbles = r; _fallback = _ocr.usingFallback; _loading = false; });
  }

  Future<void> _next() async {
    if (_idx >= _bubbles.length - 1) return;
    setState(() { _idx++; });
    await _speak(_bubbles[_idx]);
  }

  Future<void> _speak(BubbleData b) async {
    final v = VoiceManager.profileFor(b.colorName);
    await _tts.stop();
    await _tts.setLanguage("pt-BR");
    await _tts.setPitch(v.pitch);
    await _tts.setSpeechRate(v.rate);
    await _tts.speak(b.text);
  }

  Future<void> _exportAll() async {
    for (int i = 0; i < _bubbles.length; i++) {
      final v = VoiceManager.profileFor(_bubbles[i].colorName);
      await AudioExporter.exportToWav(
        text: _bubbles[i].text, pitch: v.pitch,
        rate: v.rate, fileName: 'bubble_$i',
      );
    }
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Audio exportado para Documents')));
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leitor Gibi SOTA'),
        backgroundColor: Colors.green.shade200,
        actions: [
          if (_bubbles.isNotEmpty)
            IconButton(icon: const Icon(Icons.download), onPressed: _exportAll, tooltip: 'Exportar Audio'),
        ],
      ),
      body: _loading
        ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator(), SizedBox(height: 16),
                       Text('A processar imagem...', style: TextStyle(fontSize: 18))]))
        : Column(children: [
            if (_img != null) Container(height: 180, margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                image: DecorationImage(image: MemoryImage(_img!), fit: BoxFit.contain))),
            if (_fallback && _bubbles.isNotEmpty) Container(
              color: Colors.orange.shade100, padding: const EdgeInsets.all(6),
              child: const Text('Modelo ONNX ausente - dados simulados ativos',
                style: TextStyle(fontSize: 11))),
            Expanded(child: _bubbles.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.image, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Nenhum balao detetado', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(onPressed: _pick,
                    icon: const Icon(Icons.upload), label: const Text('Carregar Imagem')),
                ]))
              : ListView.builder(padding: const EdgeInsets.all(12),
                  itemCount: _bubbles.length,
                  itemBuilder: (c, i) {
                    final b = _bubbles[i];
                    final v = VoiceManager.profileFor(b.colorName);
                    final a = i == _idx;
                    return Card(elevation: a ? 8 : 2,
                      color: a ? Colors.green.shade100 : Colors.white,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: Icon(a ? Icons.volume_up : Icons.chat_bubble_outline,
                          color: a ? Colors.green : Colors.grey, size: 32),
                        title: Text(b.text, style: TextStyle(fontSize: 17,
                          fontWeight: a ? FontWeight.bold : FontWeight.normal)),
                        subtitle: Text('Voz: ${v.name} (pitch ${v.pitch})',
                          style: const TextStyle(fontSize: 11)),
                        onTap: () async {
                          setState(() { _idx = i; _reading = false; });
                          await _speak(b);
                        },
                      ));
                  })),
            Padding(padding: const EdgeInsets.all(10),
              child: Row(children: [
                if (_img == null)
                  Expanded(child: ElevatedButton.icon(onPressed: _pick,
                    icon: const Icon(Icons.upload), label: const Text('UPLOAD'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(0, 56))))
                else
                  Expanded(child: ElevatedButton.icon(onPressed: () {
                    setState(() { _reading = true; _idx = -1; }); _next();
                  }, icon: const Icon(Icons.play_arrow), label: const Text('LER TUDO'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(0, 56),
                      backgroundColor: Colors.green, foregroundColor: Colors.white))),
              ])),
          ]),
    );
  }
}
