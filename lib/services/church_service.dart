import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/church_info_model.dart';

class ChurchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener información de la iglesia
  Stream<ChurchInfo?> getChurchInfo() {
    return _firestore
        .collection('church_info')
        .doc('main')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return ChurchInfo.fromFirestore(snapshot);
      }
      return null;
    });
  }

  // Obtener información una sola vez (sin stream)
  Future<ChurchInfo?> getChurchInfoOnce() async {
    try {
      final doc = await _firestore.collection('church_info').doc('main').get();
      if (doc.exists) {
        return ChurchInfo.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error obteniendo church info: $e');
      return null;
    }
  }
}