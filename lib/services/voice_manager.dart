class VoiceProfile {
  final String name;
  final double pitch;
  final double rate;
  const VoiceProfile(this.name, this.pitch, this.rate);
}

class VoiceManager {
  static const Map<String, VoiceProfile> _m = {
    'red': VoiceProfile('Monica', 1.5, 0.55),
    'blue': VoiceProfile('Cebolinha', 0.8, 0.40),
    'green': VoiceProfile('Magali', 1.2, 0.50),
    'white': VoiceProfile('Narrador', 1.0, 0.45),
    'black': VoiceProfile('Narrador', 1.0, 0.45),
    'mixed': VoiceProfile('Generico', 1.1, 0.50),
    'unknown': VoiceProfile('Generico', 1.1, 0.50),
  };

  static VoiceProfile profileFor(String c) => _m[c] ?? _m['unknown']!;
}
