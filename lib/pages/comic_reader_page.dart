import 'package:flutter/material.dart';
import 'package:flutter_tts_improved/flutter_tts_improved.dart';
import '../services/ocr_service.dart';

class ComicReaderPage extends StatefulWidget {
  final String comicPath;

  const ComicReaderPage({super.key, required this.comicPath});

  @override
  State<ComicReaderPage> createState() => _ComicReaderPageState();
}

class _ComicReaderPageState extends State<ComicReaderPage> {
  final FlutterTtsImproved _tts = FlutterTtsImproved();
  final OcrService _ocrService = OcrService();
  
  List<BubbleData> _bubbles = [];
  bool _isLoading = true;
  int _currentIndex = -1;

  // Configuracao de vozes por personagem (Pitch = tom, Rate = velocidade)
  final List<Map<String, double>> _voices = [
    {'pitch': 1.5, 'rate': 0.6}, // Personagem 0: Agudo (Monica)
    {'pitch': 0.8, 'rate': 0.4}, // Personagem 1: Grave (Cebolinha)
    {'pitch': 1.2, 'rate': 0.5}, // Personagem 2: Medio (Magali)
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadOcr();
  }

  void _initTts() {
    _tts.setCompletionHandler(() {
      if (_currentIndex < _bubbles.length - 1) {
        _readNext();
      } else {
        setState(() { _currentIndex = -1; });
      }
    });
  }

  Future<void> _loadOcr() async {
    final result = await _ocrService.extractBubbles(widget.comicPath);
    setState(() {
      _bubbles = result;
      _isLoading = false;
    });
  }

  Future<void> _readNext() async {
    if (_currentIndex >= _bubbles.length - 1) return;
    
    setState(() { _currentIndex++; });
    
    final bubble = _bubbles[_currentIndex];
    final voice = _voices[bubble.speakerId % _voices.length];
    
    await _tts.stop();
    await _tts.setLanguage("pt-BR");
    await _tts.setPitch(voice['pitch']!);
    await _tts.setSpeechRate(voice['rate']!);
    await _tts.speak(bubble.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A Ler Gibi...'),
        backgroundColor: Colors.green.shade200,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _bubbles.length,
                    itemBuilder: (context, index) {
                      bool isReading = index == _currentIndex;
                      return Card(
                        elevation: isReading ? 8 : 2,
                        color: isReading ? Colors.green.shade100 : Colors.white,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: Icon(
                            isReading ? Icons.volume_up : Icons.chat_bubble_outline,
                            color: isReading ? Colors.green : Colors.grey,
                            size: 32,
                          ),
                          title: Text(
                            _bubbles[index].text,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: isReading ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          onTap: () {
                            setState(() { _currentIndex = index; });
                            final voice = _voices[_bubbles[index].speakerId % _voices.length];
                            _tts.setPitch(voice['pitch']!);
                            _tts.setSpeechRate(voice['rate']!);
                            _tts.speak(_bubbles[index].text);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _readNext,
                    icon: const Icon(Icons.play_arrow, size: 32),
                    label: const Text('LER TUDO', style: TextStyle(fontSize: 24)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
