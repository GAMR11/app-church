import 'package:cloud_firestore/cloud_firestore.dart';

class ChurchInfo {
 final String nombre;
 final String descripcion;
 final String slogan;
 final String telefono;
 final String? telefono2;
 final String email;
 final String sitioWeb;
 final List<String> imagenesCarrusel;
 final Map<String, String> redesSociales;
 final List<HorarioServicio> horarios;
final String quienesSomos;
final MisionVision mision;
final MisionVision vision;
final List<String> valores;
final String valoresTexto;
final List<Ubicacion> ubicaciones;
final List<String> declaracionFe;

 ChurchInfo({
  required this.nombre,
  required this.descripcion,
  required this.slogan,
  required this.telefono,
  this.telefono2,
  required this.email,
  required this.sitioWeb,
  required this.imagenesCarrusel,
  required this.redesSociales,
  required this.horarios,
  required this.quienesSomos,
  required this.mision,
  required this.vision,
  required this.valores,
  required this.valoresTexto,
  required this.ubicaciones,
  required this.declaracionFe,
 });

 factory ChurchInfo.fromFirestore(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  // Función auxiliar robusta para manejar Arrays (List) o Maps numerados (LinkedMap)
  List<dynamic> _getListFromFirestore(dynamic firestoreData) {
   if (firestoreData is List) {
    return firestoreData;
   }
   if (firestoreData is Map) {
    // Si es un Map (LinkedMap), extrae solo los valores.
    return firestoreData.values.toList();
   }
   return [];
  }
  
  // --- Lógica para imagenesCarrusel ---
  final List<String> loadedImages = _getListFromFirestore(data['imagenesCarrusel'])
    .map((e) => e.toString())
    .toList();
    
  // --- Lógica para horarios (Usa la función para extraer los elementos del mapa padre) ---
  final List<HorarioServicio> loadedHorarios = _getListFromFirestore(data['horarios'])
    .map((h) {
     if (h is Map<String, dynamic>) {
      return HorarioServicio.fromMap(h);
     }
     return null; 
    })
    .whereType<HorarioServicio>()
    .toList();


  return ChurchInfo(
   nombre: data['nombre'] ?? '',
   descripcion: data['descripcion'] ?? '',
   slogan: data['slogan'] ?? '',
   telefono: data['telefono'] ?? '',
   telefono2: data['telefono2'],
   email: data['email'] ?? '',
   sitioWeb: data['sitioWeb'] ?? '',
   
   // Usamos las variables corregidas
   imagenesCarrusel: loadedImages,
   redesSociales: Map<String, String>.from(data['redesSociales'] ?? {}),
   horarios: loadedHorarios,
   
   // Campos comentados (mantienen la estructura original)
   quienesSomos: data['quienesSomos'] ?? '',
   mision: MisionVision.fromMap(data['mision'] ?? {}),
   vision: MisionVision.fromMap(data['vision'] ?? {}),
   valores: List<String>.from(data['valores'] ?? []),
   valoresTexto: data['valoresTexto'] ?? '',
   ubicaciones: (data['ubicaciones'] is List)
     ? (data['ubicaciones'] as List<dynamic>)?.map((u) => Ubicacion.fromMap(u)).toList() ?? []
     : _getListFromFirestore(data['ubicaciones'])?.map((u) => Ubicacion.fromMap(u)).toList() ?? [],
   declaracionFe: List<String>.from(data['declaracionFe'] ?? []),
  );
 }
}

class HorarioServicio {
 final String dia;
 final List<String> servicios;

 HorarioServicio({
  required this.dia,
  required this.servicios,
 });

 factory HorarioServicio.fromMap(Map<String, dynamic> map) {
    
    // Función auxiliar local para manejar el subcampo 'servicios'
    List<dynamic> _getListFromMap(dynamic mapData) {
      if (mapData is List) {
        return mapData;
      }
      if (mapData is Map) {
        return mapData.values.toList();
      }
      return [];
    }
    
  return HorarioServicio(
   dia: map['dia'] ?? '',
   // Aplicamos la misma lógica de corrección al subcampo 'servicios'
   servicios: _getListFromMap(map['servicios'])
        .map((e) => e.toString())
        .toList(),
  );
 }
}
// ... (MisionVision, Versiculo, Ubicacion permanecen igual)
// Los dejaremos al final para no hacer el código excesivamente largo.
// ...

class MisionVision {
final String titulo;
final String subtitulo;
final Versiculo? versiculo;
final Versiculo? versiculo1;
final Versiculo? versiculo2;
final String? inspiracion;
final List<String>? puntos;

MisionVision({
 required this.titulo,
 required this.subtitulo,
 this.versiculo,
 this.versiculo1,
 this.versiculo2,
 this.inspiracion,
 this.puntos,
});

factory MisionVision.fromMap(Map<String, dynamic> map) {
 return MisionVision(
 titulo: map['titulo'] ?? '',
 subtitulo: map['subtitulo'] ?? '',
 versiculo: map['versiculo'] != null
  ? Versiculo.fromMap(map['versiculo'])
  : null,
 versiculo1: map['versiculo1'] != null
  ? Versiculo.fromMap(map['versiculo1'])
  : null,
 versiculo2: map['versiculo2'] != null
  ? Versiculo.fromMap(map['versiculo2'])
  : null,
 inspiracion: map['inspiracion'],
 puntos: map['puntos'] != null ? List<String>.from(map['puntos']) : null,
 );
}
}

class Versiculo {
final String texto;
final String referencia;

Versiculo({
 required this.texto,
 required this.referencia,
});

factory Versiculo.fromMap(Map<String, dynamic> map) {
 return Versiculo(
 texto: map['texto'] ?? '',
 referencia: map['referencia'] ?? '',
 );
}
}

class Ubicacion {
final String nombre;
final String direccion;

Ubicacion({
 required this.nombre,
 required this.direccion,
});

factory Ubicacion.fromMap(Map<String, dynamic> map) {
 return Ubicacion(
 nombre: map['nombre'] ?? '',
 direccion: map['direccion'] ?? '',
 );
}
}