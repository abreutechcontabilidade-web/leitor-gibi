class MavisEngine {
  static final Map<String, List<String>> _knowledgeGraph = {
    "chico bento": ["caipira", "namora a rosinha", "amigo do ze lele"],
    "rosinha": ["namorada do chico bento", "menina do campo"],
    "monica": ["dentucinha", "dona da rua", "forte"],
  };

  static Future<Map<String, dynamic>> processComplexIntent(String query) async {
    print("[MAVIS-LEADER] Acordando enxame...");
    await Future.delayed(const Duration(milliseconds: 600));
    
    String response = "";
    int learnedOpcode = 0xFFFF;
    String q = query.toLowerCase();

    if (q.contains("vira a folha") || q.contains("passa a pagina")) learnedOpcode = 0xAA03;
    if (q.contains("para de ler") || q.contains("silencio")) learnedOpcode = 0xAA02;
    if (q.contains("le pra mim") || q.contains("comeca a ler")) learnedOpcode = 0xAA01;

    for (var entity in _knowledgeGraph.keys) {
      if (q.contains(entity)) {
        response = "Eu sei sobre $entity: ${_knowledgeGraph[entity]!.join(', ')}.";
        break;
      }
    }

    if (response.isEmpty) {
      response = "Ainda nao sei responder isso. O cerebro neural local ainda nao foi instalado.";
    }

    print("[MAVIS-VERIFIER] Validando resposta...");
    await Future.delayed(const Duration(milliseconds: 200));
    
    return {"text": response, "learned_opcode": learnedOpcode};
  }
}