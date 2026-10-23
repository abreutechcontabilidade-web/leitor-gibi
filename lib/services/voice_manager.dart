import 'stilb_emotion.dart';

class VoiceManager {
  static VoiceProfile profileFor(String colorName) {
    // Perfis base por personagem (pode ser expandido)
    if (colorName == 'red') return VoiceProfile(1.0, 0.5);
    if (colorName == 'blue') return VoiceProfile(0.8, 0.4);
    return VoiceProfile(1.0, 0.5);
  }

  // NOVO: Lê o texto e aplica a emoção STILB por cima do perfil do personagem
  static VoiceProfile emotionalProfileFor(String colorName, String text) {
    VoiceProfile base = profileFor(colorName);
    VoiceProfile emotion = StilbEmotionEngine.analyze(text);
    
    return VoiceProfile(
      (base.pitch + (emotion.pitch - 1.0)).clamp(0.5, 2.0), 
      (base.rate + (emotion.rate - 0.5)).clamp(0.1, 1.0)
    );
  }
}