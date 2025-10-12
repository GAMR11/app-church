import 'package:cloud_firestore/cloud_firestore.dart';

class TeamMember {
  final String id;
  final String nombre;
  final String rol;
  final String cargo;
  final String imagenUrl;
  final String descripcion;
  final int orden;
  final bool activo;
  final String? fechaOrdenacion;
  final String? telefono;
  final String? email;

  TeamMember({
    required this.id,
    required this.nombre,
    required this.rol,
    required this.cargo,
    required this.imagenUrl,
    required this.descripcion,
    this.orden = 0,
    this.activo = true,
    this.fechaOrdenacion,
    this.telefono,
    this.email,
  });

  factory TeamMember.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return TeamMember(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      rol: data['rol'] ?? '',
      cargo: data['cargo'] ?? '',
      imagenUrl: data['imagenUrl'] ?? '',
      descripcion: data['descripcion'] ?? '',
      orden: data['orden'] ?? 0,
      activo: data['activo'] ?? true,
      fechaOrdenacion: data['fechaOrdenacion'],
      telefono: data['telefono'],
      email: data['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'rol': rol,
      'cargo': cargo,
      'imagenUrl': imagenUrl,
      'descripcion': descripcion,
      'orden': orden,
      'activo': activo,
      'fechaOrdenacion': fechaOrdenacion,
      'telefono': telefono,
      'email': email,
    };
  }
}