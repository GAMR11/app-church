// lib/screens/mas_screen.dart
import 'package:flutter/material.dart';

class MasScreen extends StatelessWidget {
  const MasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Más'),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: const Center(
        child: Text('Pantalla de Más\n(En desarrollo)'),
      ),
    );
  }
}