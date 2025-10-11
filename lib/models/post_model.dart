import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String tipo; // 'evento', 'video', 'anuncio', etc.
  final String titulo;
  final String? subtitulo;
  final String? descripcion;
  final String? imagenUrl;
  final String? videoUrl;
  final DateTime fechaPublicacion;
  final DateTime? fechaEvento;
  final List<String>? horarios;
  final List<String>? ubicaciones;
  final String? costo;
  final String autor;

  Post({
    required this.id,
    required this.tipo,
    required this.titulo,
    this.subtitulo,
    this.descripcion,
    this.imagenUrl,
    this.videoUrl,
    required this.fechaPublicacion,
    this.fechaEvento,
    this.horarios,
    this.ubicaciones,
    this.costo,
    required this.autor,
  });

  // Crear Post desde Firestore
  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Post(
      id: doc.id,
      tipo: data['tipo'] ?? 'anuncio',
      titulo: data['titulo'] ?? '',
      subtitulo: data['subtitulo'],
      descripcion: data['descripcion'],
      imagenUrl: data['imagenUrl'],
      videoUrl: data['videoUrl'],
      fechaPublicacion: (data['fechaPublicacion'] as Timestamp).toDate(),
      fechaEvento: data['fechaEvento'] != null 
          ? (data['fechaEvento'] as Timestamp).toDate() 
          : null,
      horarios: data['horarios'] != null 
          ? List<String>.from(data['horarios']) 
          : null,
      ubicaciones: data['ubicaciones'] != null 
          ? List<String>.from(data['ubicaciones']) 
          : null,
      costo: data['costo'],
      autor: data['autor'] ?? 'Iglesia.Casa',
    );
  }

  // Convertir Post a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'titulo': titulo,
      'subtitulo': subtitulo,
      'descripcion': descripcion,
      'imagenUrl': imagenUrl,
      'videoUrl': videoUrl,
      'fechaPublicacion': Timestamp.fromDate(fechaPublicacion),
      'fechaEvento': fechaEvento != null 
          ? Timestamp.fromDate(fechaEvento!) 
          : null,
      'horarios': horarios,
      'ubicaciones': ubicaciones,
      'costo': costo,
      'autor': autor,
    };
  }
}