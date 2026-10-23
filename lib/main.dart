import 'package:flutter/material.dart';
import 'pages/comic_reader_page.dart';

void main() {
  runApp(const LeitorGibiApp());
}

class LeitorGibiApp extends StatelessWidget {
  const LeitorGibiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leitor Gibi SOTA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prateleira SOTA'),
        backgroundColor: Colors.green.shade200,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_stories, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text('Bem-vindo ao Leitor de Gibi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(250, 60),
              ),
              icon: const Icon(Icons.play_arrow, size: 30),
              label: const Text('ABRIR LEITOR E OUVIR', style: TextStyle(fontSize: 18)),
              onPressed: () {
                // Rota para a nossa tela com Multi-Vozes!
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ComicReaderPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}