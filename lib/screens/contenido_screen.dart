

// lib/screens/contenido_screen.dart
import 'package:flutter/material.dart';

class ContenidoScreen extends StatelessWidget {
  const ContenidoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contenido'),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: const Center(
        child: Text('Pantalla de Contenido\n(En desarrollo)'),
      ),
    );
  }
}

