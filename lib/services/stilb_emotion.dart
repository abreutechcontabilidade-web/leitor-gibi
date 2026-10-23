import 'dart:math';

class VoiceProfile {
  final double pitch;
  final double rate;
  VoiceProfile(this.pitch, this.rate);
}

class StilbEmotionEngine {
  /// Analisa o texto de forma determinística (Sem LLM) e devolve a emoção da voz.
  static VoiceProfile analyze(String text) {
    double basePitch = 1.0;
    double baseRate = 0.5;

    // 1. Detetar Gritos / Exclamações
    int exclamations = '!'.allMatches(text).length;
    if (exclamations > 0) {
      basePitch += 0.2 * exclamations; // Grito mais agudo
      baseRate += 0.1 * exclamations;  // Grito mais rápido
    }

    // 2. Detetar Dúvida / Perguntas
    int questions = '?'.allMatches(text).length;
    if (questions > 0) {
      basePitch += 0.1 * questions;
      baseRate -= 0.05 * questions; // Fala mais devagar (confuso)
    }

    // 3. Detetar Suspense
    if (text.contains('...')) {
      baseRate -= 0.15;
      basePitch -= 0.1;
    }

    // 4. Detetar Maiúsculas (Volume/Grito)
    String cleanText = text.replaceAll(RegExp(r'[^a-zA-Z]'), '');
    if (cleanText.isNotEmpty && cleanText == cleanText.toUpperCase()) {
      basePitch += 0.15;
      baseRate += 0.05;
    }

    // Limitar os valores para não quebrar o TTS (Pitch 0.5 a 2.0 | Rate 0.1 a 1.0)
    basePitch = basePitch.clamp(0.5, 2.0);
    baseRate = baseRate.clamp(0.1, 1.0);

    return VoiceProfile(basePitch, baseRate);
  }
}