import 'nano_bus.dart';
import 'stilb_core.dart';
import 'mavis_engine.dart';

class OmniBrain {
  final NanoBus _bus = NanoBus();

  OmniBrain() { _initSynapses(); }

  Future<void> _initSynapses() async {
    await StilbCore.initMemory();

    _bus.on("STT_INPUT", (dynamic text) async {
      String query = text.toString();
      int opcode = StilbCore.processIntent(query);
      
      if (opcode == StilbCore.OP_NONE) {
        print("[OMNI-BRAIN] Ruido ignorado: $query");
        return;
      }

      if (opcode != StilbCore.OP_LLM_QUERY) {
        _bus.emit("ACTION_EXECUTE", opcode);
      } else {
        _bus.emit("UI_THINKING", true);
        Map<String, dynamic> mavisResult = await MavisEngine.processComplexIntent(query);
        _bus.emit("UI_THINKING", false);
        
        if (mavisResult["learned_opcode"] != 0xFFFF) {
          await StilbCore.learn(query, mavisResult["learned_opcode"]);
        }
        
        _bus.emit("ACTION_SPEAK", mavisResult["text"]);
      }
    });
  }
}