import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/video_model.dart';

class ContentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener videos por categoría
  Stream<List<Video>> getVideosByCategory(String categoria) {
    return _firestore
        .collection('contenido')
        .where('categoria', isEqualTo: categoria)
        .where('activo', isEqualTo: true)
        .orderBy('fechaPublicacion', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Video.fromFirestore(doc)).toList();
    });
  }

  // Obtener todos los videos
  Stream<List<Video>> getAllVideos() {
    return _firestore
        .collection('contenido')
        .where('activo', isEqualTo: true)
        .orderBy('fechaPublicacion', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Video.fromFirestore(doc)).toList();
    });
  }

  // Incrementar visualizaciones
  Future<void> incrementViews(String videoId) async {
    await _firestore.collection('contenido').doc(videoId).update({
      'visualizaciones': FieldValue.increment(1),
    });
  }
}