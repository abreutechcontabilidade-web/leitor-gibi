import 'package:flutter/material.dart';

class LumaBotao extends StatelessWidget {
  const LumaBotao({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      onPressed: () {},
      child: const Text('LUMA'),
    );
  }
}