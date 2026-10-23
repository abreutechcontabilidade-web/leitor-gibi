import 'package:shared_preferences/shared_preferences.dart';

class StilbCore {
  static const int OP_READ = 0xAA01;
  static const int OP_STOP = 0xAA02;
  static const int OP_NEXT = 0xAA03;
  static const int OP_PREV = 0xAA04;
  static const int OP_LLM_QUERY = 0xFFFF;
  static const int OP_NONE = 0xEEEE;

  static final Map<String, int> _lut = {
    "ler": OP_READ, "continuar": OP_READ, "play": OP_READ,
    "parar": OP_STOP, "pausar": OP_STOP, "stop": OP_STOP,
    "proxima": OP_NEXT, "avancar": OP_NEXT, "proximo": OP_NEXT,
    "voltar": OP_PREV, "anterior": OP_PREV,
  };

  static String _normalizar(String text) {
    return text.toLowerCase()
      .replaceAll(RegExp(r'[\u00e1\u00e0\u00e2\u00e3\u00e4]'), 'a')
      .replaceAll(RegExp(r'[\u00e9\u00e8\u00ea\u00eb]'), 'e')
      .replaceAll(RegExp(r'[\u00ed\u00ec\u00ee\u00ef]'), 'i')
      .replaceAll(RegExp(r'[\u00f3\u00f2\u00f4\u00f5\u00f6]'), 'o')
      .replaceAll(RegExp(r'[\u00fa\u00f9\u00fb\u00fc]'), 'u')
      .replaceAll(RegExp(r'[\u00e7]'), 'c');
  }

  static Future<void> initMemory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (String key in prefs.getKeys()) {
        if (key.startsWith("learned_")) {
          _lut[key.replaceFirst("learned_", "")] = prefs.getInt(key) ?? OP_LLM_QUERY;
        }
      }
    } catch (e) { print("[STILB] Erro de memoria: $e"); }
  }

  static Future<void> learn(String newWord, int opcode) async {
    String word = _normalizar(newWord.trim());
    if (word.isEmpty || _lut.containsKey(word)) return;
    _lut[word] = opcode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("learned_$word", opcode);
    } catch (e) { print("[STILB] Erro ao gravar: $e"); }
  }

  static int processIntent(String text) {
    final cleanText = _normalizar(text);
    final words = cleanText.split(' ');
    for (var word in words) {
      if (_lut.containsKey(word)) return _lut[word]!;
    }
    final questionMarkers = ["explica", "quem", "qual", "porque", "por que", "moral", "historia", "resumo"];
    for (var marker in questionMarkers) {
      if (cleanText.contains(marker)) return OP_LLM_QUERY;
    }
    return OP_NONE;
  }
}