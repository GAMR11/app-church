import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  final String id;
  final String titulo;
  final String? descripcion;
  final List<String> fotos; // URLs de las fotos
  final DateTime fechaPublicacion;
  final String? ubicacion;
  final bool activo;
  final int totalFotos;

  Album({
    required this.id,
    required this.titulo,
    this.descripcion,
    required this.fotos,
    required this.fechaPublicacion,
    this.ubicacion,
    this.activo = true,
    required this.totalFotos,
  });

  factory Album.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Función auxiliar para manejar arrays/maps
    List<String> getFotosList(dynamic fotosData) {
      if (fotosData is List) {
        return fotosData.map((e) => e.toString()).toList();
      }
      if (fotosData is Map) {
        return fotosData.values.map((e) => e.toString()).toList();
      }
      return [];
    }

    final fotos = getFotosList(data['fotos']);

    return Album(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'],
      fotos: fotos,
      fechaPublicacion: (data['fechaPublicacion'] as Timestamp).toDate(),
      ubicacion: data['ubicacion'],
      activo: data['activo'] ?? true,
      totalFotos: fotos.length,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'fotos': fotos,
      'fechaPublicacion': Timestamp.fromDate(fechaPublicacion),
      'ubicacion': ubicacion,
      'activo': activo,
      'totalFotos': totalFotos,
    };
  }

  // Primera foto como portada
  String get portada => fotos.isNotEmpty ? fotos.first : '';
}