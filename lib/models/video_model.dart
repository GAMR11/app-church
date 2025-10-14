import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  final String id;
  final String titulo;
  final String? descripcion;
  final String thumbnailUrl;
  final String videoUrl;
  final String categoria; // 'videos', 'playlist', 'devocionales', etc.
  final DateTime fechaPublicacion;
  final String? autor;
  final int? duracion; // en segundos
  final int visualizaciones;
  final bool activo;

  Video({
    required this.id,
    required this.titulo,
    this.descripcion,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.categoria,
    required this.fechaPublicacion,
    this.autor,
    this.duracion,
    this.visualizaciones = 0,
    this.activo = true,
  });

  factory Video.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Video(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'],
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      categoria: data['categoria'] ?? 'videos',
      fechaPublicacion: (data['fechaPublicacion'] as Timestamp).toDate(),
      autor: data['autor'],
      duracion: data['duracion'],
      visualizaciones: data['visualizaciones'] ?? 0,
      activo: data['activo'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'categoria': categoria,
      'fechaPublicacion': Timestamp.fromDate(fechaPublicacion),
      'autor': autor,
      'duracion': duracion,
      'visualizaciones': visualizaciones,
      'activo': activo,
    };
  }

  // Extraer ID de YouTube desde URL
  String? get youtubeId {
    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
      final regExp = RegExp(
        r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
      );
      final match = regExp.firstMatch(videoUrl);
      return match?.group(1);
    }
    return null;
  }
}