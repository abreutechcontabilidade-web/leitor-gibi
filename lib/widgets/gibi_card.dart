import 'package:flutter/material.dart';

class GibiCard extends StatelessWidget {
  final String titulo;
  final String imagemUrl;
  final VoidCallback onTap;

  const GibiCard({
    super.key,
    required this.titulo,
    required this.imagemUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(imagemUrl, fit: BoxFit.cover, width: double.infinity),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.green.shade100,
              child: Text(
                titulo,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
