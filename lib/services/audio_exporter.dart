import 'package:flutter_tts_improved/flutter_tts_improved.dart';
import 'package:path_provider/path_provider.dart';

class AudioExporter {
  static Future<String?> exportToWav({
    required String text, required double pitch,
    required double rate, required String fileName,
  }) async {
    try {
      final tts = FlutterTtsImproved();
      await tts.setLanguage("pt-BR");
      await tts.setPitch(pitch);
      await tts.setSpeechRate(rate);
      await tts.synthesizeToFile(text, fileName);
      final dir = await getApplicationDocumentsDirectory();
      return '${dir.path}/$fileName.wav';
    } catch (e) {
      print('[AudioExporter] $e');
      return null;
    }
  }
}
