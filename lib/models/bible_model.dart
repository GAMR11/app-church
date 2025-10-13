class BibliaLibro {
  final String id;
  final String nombre;
  final String abreviatura;
  final String testamento; // "Antiguo" o "Nuevo"
  final int totalCapitulos;
  final int orden;

  BibliaLibro({
    required this.id,
    required this.nombre,
    required this.abreviatura,
    required this.testamento,
    required this.totalCapitulos,
    required this.orden,
  });
}

class BibliaCapitulo {
  final String libro;
  final int capitulo;
  final List<BibliaVersiculo> versiculos;

  BibliaCapitulo({
    required this.libro,
    required this.capitulo,
    required this.versiculos,
  });
}

class BibliaVersiculo {
  final int numero;
  final String texto;

  BibliaVersiculo({
    required this.numero,
    required this.texto,
  });
}