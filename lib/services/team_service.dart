import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/team_member_model.dart';

class TeamService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener todos los miembros activos
  Stream<List<TeamMember>> getTeamMembers() {
    return _firestore
        .collection('equipo')
        .where('activo', isEqualTo: true)
        .orderBy('orden')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TeamMember.fromFirestore(doc))
          .toList();
    });
  }

  // Obtener miembros por rol
  Stream<List<TeamMember>> getMembersByRole(String rol) {
    return _firestore
        .collection('equipo')
        .where('rol', isEqualTo: rol)
        .where('activo', isEqualTo: true)
        .orderBy('orden')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TeamMember.fromFirestore(doc))
          .toList();
    });
  }

  // Obtener miembro por ID
  Future<TeamMember?> getMemberById(String id) async {
    try {
      final doc = await _firestore.collection('equipo').doc(id).get();
      if (doc.exists) {
        return TeamMember.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error obteniendo miembro: $e');
      return null;
    }
  }

  // Agregar miembro (útil para admin)
  Future<void> addMember(TeamMember member) async {
    await _firestore.collection('equipo').add(member.toMap());
  }
}