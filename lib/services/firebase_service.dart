import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Referencia a la colección de posts
  CollectionReference get postsCollection => _firestore.collection('posts');

  // Obtener posts en tiempo real (stream)
  Stream<List<Post>> getPosts() {
    return postsCollection
        .orderBy('fechaPublicacion', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    });
  }

  // Obtener posts por tipo
  Stream<List<Post>> getPostsByTipo(String tipo) {
    return postsCollection
        .where('tipo', isEqualTo: tipo)
        .orderBy('fechaPublicacion', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    });
  }

  // Agregar un nuevo post (útil para pruebas)
  Future<void> addPost(Post post) async {
    await postsCollection.add(post.toMap());
  }

  // Actualizar un post
  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    await postsCollection.doc(postId).update(data);
  }

  // Eliminar un post
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }
}