import 'package:flutter/material.dart';
import 'widgets/gibi_card.dart';
import 'widgets/luma_botao.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leitor Gibi SOTA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const EstanteDeGibis(),
    );
  }
}

class EstanteDeGibis extends StatelessWidget {
  const EstanteDeGibis({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> gibis = [
      {'titulo': 'Turma da Monica', 'img': 'https://picsum.photos/200/300?1'},
      {'titulo': 'Mickey Mouse', 'img': 'https://picsum.photos/200/300?2'},
      {'titulo': 'Homem Aranha', 'img': 'https://picsum.photos/200/300?3'},
      {'titulo': 'Batman', 'img': 'https://picsum.photos/200/300?4'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leitor Gibi SOTA', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade200,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: gibis.length,
        itemBuilder: (context, index) {
          return GibiCard(
            titulo: gibis[index]['titulo']!,
            imagemUrl: gibis[index]['img']!,
            onTap: () {
              print('Abrindo: \${gibis[index]['titulo']}');
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.play_arrow),
        label: const Text('LER', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.green,
      ),
    );
  }
}
