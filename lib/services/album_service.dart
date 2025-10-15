import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/album_model.dart';

class AlbumService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener todos los álbumes
  Stream<List<Album>> getAlbums() {
    return _firestore
        .collection('albums')
        .snapshots()
        .map((snapshot) {
      final albums = snapshot.docs
          .map((doc) => Album.fromFirestore(doc))
          .where((album) => album.activo)
          .toList();
      
      // Ordenar por fecha
      albums.sort((a, b) => b.fechaPublicacion.compareTo(a.fechaPublicacion));
      
      return albums;
    });
  }

  // Obtener álbum por ID
  Future<Album?> getAlbumById(String id) async {
    try {
      final doc = await _firestore.collection('albums').doc(id).get();
      if (doc.exists) {
        return Album.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error obteniendo álbum: $e');
      return null;
    }
  }
}