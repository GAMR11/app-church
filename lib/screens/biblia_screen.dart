import 'package:flutter/material.dart';
import '../models/bible_model.dart';
import '../services/bible_service.dart';
import 'biblia_chapter_screen.dart';

class BibliaScreen extends StatefulWidget {
  const BibliaScreen({Key? key}) : super(key: key);

  @override
  State<BibliaScreen> createState() => _BibliaScreenState();
}

class _BibliaScreenState extends State<BibliaScreen> {
  String _testamentoSeleccionado = 'Todos';

  @override
  Widget build(BuildContext context) {
    List<BibliaLibro> libros;
    
    if (_testamentoSeleccionado == 'Antiguo') {
      libros = BibleService.getLibrosByTestamento('Antiguo');
    } else if (_testamentoSeleccionado == 'Nuevo') {
      libros = BibleService.getLibrosByTestamento('Nuevo');
    } else {
      libros = BibleService.libros;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Biblia',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Búsqueda
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTestamentoFilter(),
          _buildSubtitle(),
          Expanded(
            child: ListView.builder(
              itemCount: libros.length,
              itemBuilder: (context, index) {
                return _buildLibroTile(libros[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestamentoFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterChip('Todos'),
          _buildFilterChip('Antiguo'),
          _buildFilterChip('Nuevo'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _testamentoSeleccionado == label;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _testamentoSeleccionado = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2D5F6F) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2D5F6F) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.centerLeft,
      child: Text(
        'Libros',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildLibroTile(BibliaLibro libro) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BibliaChapterScreen(libro: libro),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: libro.testamento == 'Antiguo'
                    ? const Color(0xFFB8956A).withOpacity(0.2)
                    : const Color(0xFF2D5F6F).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  libro.abreviatura,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: libro.testamento == 'Antiguo'
                        ? const Color(0xFFB8956A)
                        : const Color(0xFF2D5F6F),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    libro.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${libro.totalCapitulos} capítulos',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}