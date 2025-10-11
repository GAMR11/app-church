// lib/screens/iglesia_screen.dart
import 'package:flutter/material.dart';

class IglesiaScreen extends StatelessWidget {
  const IglesiaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iglesia'),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: const Center(
        child: Text('Pantalla de Iglesia\n(En desarrollo)'),
      ),
    );
  }
}