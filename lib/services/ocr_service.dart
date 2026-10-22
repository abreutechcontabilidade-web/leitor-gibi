import 'dart:io';
import 'dart:ui';
import 'package:onnxruntime/onnxruntime.dart';
import 'package:path_provider/path_provider.dart';

class BubbleData {
  final String text;
  final Rect boundingBox;
  final int speakerId; // 0, 1, 2 (para vozes diferentes)

  BubbleData(this.text, this.boundingBox, this.speakerId);
}

class OcrService {
  OrtSession? _bubbleSession;
  OrtSession? _ocrSession;

  Future<void> _initSessions() async {
    if (_bubbleSession != null) return;

    try {
      // Carrega os modelos ONNX dos assets
      final bubbleModel = await rootBundle.load("assets/models/bubble_pop.onnx");
      final ocrModel = await rootBundle.load("assets/models/paddle_ocr.onnx");

      _bubbleSession = await OrtSession.fromBuffer(
        bubbleModel.buffer.asUint8List(),
        OrtSessionOptions(),
      );
      _ocrSession = await OrtSession.fromBuffer(
        ocrModel.buffer.asUint8List(),
        OrtSessionOptions(),
      );
      print("[ONNX] Modelos carregados com sucesso.");
    } catch (e) {
      print("[ONNX] Falha ao carregar modelos. Usando fallback: $e");
    }
  }

  Future<List<BubbleData>> extractBubbles(String imagePath) async {
    await _initSessions();
    
    // Simula o tempo de processamento
    await Future.delayed(const Duration(milliseconds: 800));

    // Fallback para desenvolvimento (se os modelos nao existirem)
    // Se os modelos existirem, aqui seria o codigo do _bubbleSession!.run(...)
    return [
      BubbleData("Ola, eu sou a Monica!", const Rect.fromLTWH(50, 50, 200, 80), 0),
      BubbleData("Vamos brincar no parque!", const Rect.fromLTWH(150, 200, 250, 100), 1),
      BubbleData("Adoro gibis de aventura!", const Rect.fromLTWH(80, 350, 180, 90), 2),
    ];
  }
}
