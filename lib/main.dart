import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const LeitorDeGibiApp());
}

class LeitorDeGibiApp extends StatelessWidget {
  const LeitorDeGibiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leitor de Gibi para Idosos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LeitorScreen(),
    );
  }
}

class LeitorScreen extends StatefulWidget {
  const LeitorScreen({super.key});

  @override
  State<LeitorScreen> createState() => _LeitorScreenState();
}

class _LeitorScreenState extends State<LeitorScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isReading = false;

  // Texto de exemplo exibido no balão amarelo
  final String _textoGibi =
      'Olá! Eu sou o Super-Herói da Leitura! '
      'Hoje vamos embarcar numa aventura incrível juntos. '
      'Aperte o botão abaixo e eu vou contar tudo pra você!';

  @override
  void initState() {
    super.initState();
    _configurarTTS();
  }

  Future<void> _configurarTTS() async {
    // Configura idioma português do Brasil
    await _flutterTts.setLanguage('pt-BR');
    // Velocidade de fala mais lenta para melhor compreensão por idosos
    await _flutterTts.setSpeechRate(0.45);
    // Volume máximo
    await _flutterTts.setVolume(1.0);
    // Tom de voz levemente mais grave (mais confortável)
    await _flutterTts.setPitch(0.9);

    // Callback quando a leitura terminar
    _flutterTts.setCompletionHandler(() {
      setState(() => _isReading = false);
    });

    // Callback em caso de erro
    _flutterTts.setErrorHandler((message) {
      setState(() => _isReading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao ler: $message',
              style: const TextStyle(fontSize: 18)),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  Future<void> _lerEmVozAlta() async {
    if (_isReading) {
      // Se já está lendo, para a leitura
      await _flutterTts.stop();
      setState(() => _isReading = false);
    } else {
      setState(() => _isReading = true);
      await _flutterTts.speak(_textoGibi);
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Fundo creme suave
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Título Principal ──────────────────────────────────────────
              const Text(
                'Leitor de Gibi\npara Idosos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFB71C1C), // Vermelho gibi
                  height: 1.2,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 8),

              // Subtítulo / decoração
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (_) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(Icons.star, color: Color(0xFFFFB300), size: 28),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // ── Balão de Texto Amarelo ────────────────────────────────────
              _BalaoDeFala(texto: _textoGibi),

              const SizedBox(height: 48),

              // ── Botão "Ler em voz alta" ───────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 90,
                child: ElevatedButton.icon(
                  onPressed: _lerEmVozAlta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isReading
                        ? const Color(0xFFE53935) // Vermelho ao ler
                        : const Color(0xFF1B5E20), // Verde escuro padrão
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                  ),
                  icon: Icon(
                    _isReading ? Icons.stop_circle : Icons.volume_up,
                    size: 44,
                  ),
                  label: Text(
                    _isReading ? 'Parar leitura' : 'Ler em voz alta',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Dica de uso
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: Colors.blueGrey, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _isReading
                            ? 'Lendo o texto... toque no botão para parar.'
                            : 'Toque no botão verde para ouvir o texto.',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widget: Balão de Fala Amarelo ─────────────────────────────────────────────
class _BalaoDeFala extends StatelessWidget {
  final String texto;
  const _BalaoDeFala({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Corpo do balão
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEE58), // Amarelo vivo
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFFF9A825),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(4, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personagem / avatar gibi
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFB71C1C),
                    child: const Text(
                      '💬',
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Gibi fala:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Texto principal
              Text(
                texto,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        // Ponteiro/bico do balão (triângulo na parte inferior)
        Positioned(
          bottom: -26,
          left: 60,
          child: CustomPaint(
            size: const Size(40, 28),
            painter: _BalaoTrianguloPainter(),
          ),
        ),
      ],
    );
  }
}

// Pintor do triângulo do balão de fala
class _BalaoTrianguloPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = const Color(0xFFFFEE58)
      ..style = PaintingStyle.fill;

    final paintBorder = Paint()
      ..color = const Color(0xFFF9A825)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
