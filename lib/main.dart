import 'package:flutter/material.dart';
import 'widgets/luma_botao.dart';

void main() {
  runApp(LeitorDeGibiApp());
}

class LeitorDeGibiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leitor de Gibi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leitor de Gibi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LumaBotao(
              texto: 'Ler Gibi',
              onPressed: () {
                // Ação do botão
              },
            ),
            SizedBox(height: 20),
            LumaBotao(
              texto: 'Minha Coleção',
              onPressed: () {
                // Ação do botão
              },
            ),
          ],
        ),
      ),
    );
  }
}
