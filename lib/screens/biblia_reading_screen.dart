import 'package:flutter/material.dart';
import '../models/bible_model.dart';
import '../services/bible_service.dart';

class BibliaReadingScreen extends StatefulWidget {
  final BibliaLibro libro;
  final int capitulo;

  const BibliaReadingScreen({
    Key? key,
    required this.libro,
    required this.capitulo,
  }) : super(key: key);

  @override
  State<BibliaReadingScreen> createState() => _BibliaReadingScreenState();
}

class _BibliaReadingScreenState extends State<BibliaReadingScreen> {
  final BibleService _bibleService = BibleService();
  int _capituloActual = 1;

  @override
  void initState() {
    super.initState();
    _capituloActual = widget.capitulo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: widget.libro.nombre,
              dropdownColor: const Color(0xFF2D2D2D),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              underline: Container(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: BibleService.libros.map((libro) {
                return DropdownMenuItem(
                  value: libro.nombre,
                  child: Text(libro.nombre),
                );
              }).toList(),
              onChanged: (value) {
                // Cambiar libro
              },
            ),
            const SizedBox(width: 8),
            DropdownButton<int>(
              value: _capituloActual,
              dropdownColor: const Color(0xFF2D2D2D),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              underline: Container(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: List.generate(widget.libro.totalCapitulos, (index) {
                final cap = index + 1;
                return DropdownMenuItem(
                  value: cap,
                  child: Text(cap.toString()),
                );
              }),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _capituloActual = value;
                  });
                }
              },
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<BibliaCapitulo>(
        future: _bibleService.getCapitulo(widget.libro.id, _capituloActual),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No hay datos'));
          }

          final capitulo = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: capitulo.versiculos.length,
            itemBuilder: (context, index) {
              final versiculo = capitulo.versiculos[index];
              return _buildVersiculoTile(versiculo);
            },
          );
        },
      ),
    );
  }

  Widget _buildVersiculoTile(BibliaVersiculo versiculo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: '${versiculo.numero}. ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D5F6F),
              ),
            ),
            TextSpan(text: versiculo.texto),
          ],
        ),
      ),
    );
  }
}