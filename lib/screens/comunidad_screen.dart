

// lib/screens/comunidad_screen.dart
import 'package:flutter/material.dart';

class ComunidadScreen extends StatelessWidget {
  const ComunidadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: const Center(
        child: Text('Pantalla de Comunidad\n(En desarrollo)'),
      ),
    );
  }
}
