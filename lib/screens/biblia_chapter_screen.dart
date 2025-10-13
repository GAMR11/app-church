import 'package:flutter/material.dart';
import '../models/bible_model.dart';
import 'biblia_reading_screen.dart';

class BibliaChapterScreen extends StatelessWidget {
  final BibliaLibro libro;

  const BibliaChapterScreen({Key? key, required this.libro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          libro.nombre,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: libro.totalCapitulos,
        itemBuilder: (context, index) {
          final capitulo = index + 1;
          return _buildChapterButton(context, capitulo);
        },
      ),
    );
  }

  Widget _buildChapterButton(BuildContext context, int capitulo) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BibliaReadingScreen(
              libro: libro,
              capitulo: capitulo,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2D5F6F),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            capitulo.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}