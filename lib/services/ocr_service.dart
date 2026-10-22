import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'image_preprocessor.dart';
import 'bubble_postprocessor.dart';

class BubbleData {
  final String text;
  final Rect boundingBox;
  final String colorName;
  BubbleData(this.text, this.boundingBox, this.colorName);
}

class OcrService {
  OrtSession? _bubble;
  OrtSession? _ocr;
  bool _fallback = true;

  bool get usingFallback => _fallback;

  Future<void> _init() async {
    if (_bubble != null) return;
    try {
      OrtEnv.instance.init();
      final bm = await rootBundle.load("assets/models/bubble_pop.onnx");
      final om = await rootBundle.load("assets/models/paddle_ocr.onnx");
      _bubble = OrtSession.fromBuffer(bm.buffer.asUint8List(), OrtSessionOptions());
      _ocr = OrtSession.fromBuffer(om.buffer.asUint8List(), OrtSessionOptions());
      _fallback = false;
      print("[ONNX] Modelos carregados.");
    } catch (e) {
      print("[ONNX] Fallback: $e");
      _fallback = true;
    }
  }

  Future<List<BubbleData>> extractBubbles(Uint8List bytes) async {
    await _init();
    if (_fallback) return _simulated();
    try {
      final tensor = ImagePreprocessor.toNchwTensor(bytes);
      final input = OrtValueTensor.createTensorWithDataList(tensor, [1, 3, 640, 640]);
      final outputs = _bubble!.run([input]);
      final boxes = BubblePostprocessor.decodeYolo(
          outputs.isNotEmpty ? outputs[0]?.value as List? : null);
      for (final o in outputs) { o?.release(); }
      if (boxes.isEmpty) return _simulated();
      return boxes.map((b) {
        final color = ImagePreprocessor.dominantColorName(bytes, b);
        return BubbleData("[OCR real pendente]", b, color);
      }).toList();
    } catch (e) {
      print("[ONNX] Erro: $e");
      return _simulated();
    }
  }

  List<BubbleData> _simulated() => [
    BubbleData("Ola, eu sou a Monica!", const Rect.fromLTWH(50, 50, 200, 80), "red"),
    BubbleData("Vamos brincar no parque!", const Rect.fromLTWH(150, 200, 250, 100), "blue"),
    BubbleData("Adoro gibis de aventura!", const Rect.fromLTWH(80, 350, 180, 90), "green"),
  ];
}
