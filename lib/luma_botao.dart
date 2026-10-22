import 'package:flutter/material.dart';

class LumaBotao extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;

  const LumaBotao({
    Key? key,
    required this.texto,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      child: Text(texto),
    );
  }
}
