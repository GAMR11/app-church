import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bible_model.dart';

class BibleService {
  // API Key de scripture.api.bible
  static const String _apiKey = '36d4cfb9344005cfec4ba02de9f8cb1b'; // Reemplazar con tu key - iglesia-riobamba
  static const String _baseUrl = 'https://api.scripture.api.bible/v1';
  
  // ID de la versión Reina Valera 1960
  static const String _bibleId = '592420522e16049f-01'; // RVR1960

  // Mapeo de IDs de libros (API usa IDs específicos)
  static final Map<String, String> _bookIds = {
    'genesis': 'GEN',
    'exodo': 'EXO',
    'levitico': 'LEV',
    'numeros': 'NUM',
    'deuteronomio': 'DEU',
    'josue': 'JOS',
    'jueces': 'JDG',
    'rut': 'RUT',
    '1samuel': '1SA',
    '2samuel': '2SA',
    '1reyes': '1KI',
    '2reyes': '2KI',
    '1cronicas': '1CH',
    '2cronicas': '2CH',
    'esdras': 'EZR',
    'nehemias': 'NEH',
    'ester': 'EST',
    'job': 'JOB',
    'salmos': 'PSA',
    'proverbios': 'PRO',
    'eclesiastes': 'ECC',
    'cantares': 'SNG',
    'isaias': 'ISA',
    'jeremias': 'JER',
    'lamentaciones': 'LAM',
    'ezequiel': 'EZK',
    'daniel': 'DAN',
    'oseas': 'HOS',
    'joel': 'JOL',
    'amos': 'AMO',
    'abdias': 'OBA',
    'jonas': 'JON',
    'miqueas': 'MIC',
    'nahum': 'NAM',
    'habacuc': 'HAB',
    'sofonias': 'ZEP',
    'hageo': 'HAG',
    'zacarias': 'ZEC',
    'malaquias': 'MAL',
    'mateo': 'MAT',
    'marcos': 'MRK',
    'lucas': 'LUK',
    'juan': 'JHN',
    'hechos': 'ACT',
    'romanos': 'ROM',
    '1corintios': '1CO',
    '2corintios': '2CO',
    'galatas': 'GAL',
    'efesios': 'EPH',
    'filipenses': 'PHP',
    'colosenses': 'COL',
    '1tesalonicenses': '1TH',
    '2tesalonicenses': '2TH',
    '1timoteo': '1TI',
    '2timoteo': '2TI',
    'tito': 'TIT',
    'filemon': 'PHM',
    'hebreos': 'HEB',
    'santiago': 'JAS',
    '1pedro': '1PE',
    '2pedro': '2PE',
    '1juan': '1JN',
    '2juan': '2JN',
    '3juan': '3JN',
    'judas': 'JUD',
    'apocalipsis': 'REV',
  };

  // Lista completa de 66 libros
  static final List<BibliaLibro> libros = [
    // ANTIGUO TESTAMENTO
    BibliaLibro(id: 'genesis', nombre: 'Génesis', abreviatura: 'Gn', testamento: 'Antiguo', totalCapitulos: 50, orden: 1),
    BibliaLibro(id: 'exodo', nombre: 'Éxodo', abreviatura: 'Ex', testamento: 'Antiguo', totalCapitulos: 40, orden: 2),
    BibliaLibro(id: 'levitico', nombre: 'Levítico', abreviatura: 'Lv', testamento: 'Antiguo', totalCapitulos: 27, orden: 3),
    BibliaLibro(id: 'numeros', nombre: 'Números', abreviatura: 'Nm', testamento: 'Antiguo', totalCapitulos: 36, orden: 4),
    BibliaLibro(id: 'deuteronomio', nombre: 'Deuteronomio', abreviatura: 'Dt', testamento: 'Antiguo', totalCapitulos: 34, orden: 5),
    BibliaLibro(id: 'josue', nombre: 'Josué', abreviatura: 'Jos', testamento: 'Antiguo', totalCapitulos: 24, orden: 6),
    BibliaLibro(id: 'jueces', nombre: 'Jueces', abreviatura: 'Jue', testamento: 'Antiguo', totalCapitulos: 21, orden: 7),
    BibliaLibro(id: 'rut', nombre: 'Rut', abreviatura: 'Rt', testamento: 'Antiguo', totalCapitulos: 4, orden: 8),
    BibliaLibro(id: '1samuel', nombre: '1 Samuel', abreviatura: '1 S', testamento: 'Antiguo', totalCapitulos: 31, orden: 9),
    BibliaLibro(id: '2samuel', nombre: '2 Samuel', abreviatura: '2 S', testamento: 'Antiguo', totalCapitulos: 24, orden: 10),
    BibliaLibro(id: '1reyes', nombre: '1 Reyes', abreviatura: '1 R', testamento: 'Antiguo', totalCapitulos: 22, orden: 11),
    BibliaLibro(id: '2reyes', nombre: '2 Reyes', abreviatura: '2 R', testamento: 'Antiguo', totalCapitulos: 25, orden: 12),
    BibliaLibro(id: '1cronicas', nombre: '1 Crónicas', abreviatura: '1 Cr', testamento: 'Antiguo', totalCapitulos: 29, orden: 13),
    BibliaLibro(id: '2cronicas', nombre: '2 Crónicas', abreviatura: '2 Cr', testamento: 'Antiguo', totalCapitulos: 36, orden: 14),
    BibliaLibro(id: 'esdras', nombre: 'Esdras', abreviatura: 'Esd', testamento: 'Antiguo', totalCapitulos: 10, orden: 15),
    BibliaLibro(id: 'nehemias', nombre: 'Nehemías', abreviatura: 'Neh', testamento: 'Antiguo', totalCapitulos: 13, orden: 16),
    BibliaLibro(id: 'ester', nombre: 'Ester', abreviatura: 'Est', testamento: 'Antiguo', totalCapitulos: 10, orden: 17),
    BibliaLibro(id: 'job', nombre: 'Job', abreviatura: 'Job', testamento: 'Antiguo', totalCapitulos: 42, orden: 18),
    BibliaLibro(id: 'salmos', nombre: 'Salmos', abreviatura: 'Sal', testamento: 'Antiguo', totalCapitulos: 150, orden: 19),
    BibliaLibro(id: 'proverbios', nombre: 'Proverbios', abreviatura: 'Pr', testamento: 'Antiguo', totalCapitulos: 31, orden: 20),
    BibliaLibro(id: 'eclesiastes', nombre: 'Eclesiastés', abreviatura: 'Ec', testamento: 'Antiguo', totalCapitulos: 12, orden: 21),
    BibliaLibro(id: 'cantares', nombre: 'Cantares', abreviatura: 'Cnt', testamento: 'Antiguo', totalCapitulos: 8, orden: 22),
    BibliaLibro(id: 'isaias', nombre: 'Isaías', abreviatura: 'Is', testamento: 'Antiguo', totalCapitulos: 66, orden: 23),
    BibliaLibro(id: 'jeremias', nombre: 'Jeremías', abreviatura: 'Jer', testamento: 'Antiguo', totalCapitulos: 52, orden: 24),
    BibliaLibro(id: 'lamentaciones', nombre: 'Lamentaciones', abreviatura: 'Lm', testamento: 'Antiguo', totalCapitulos: 5, orden: 25),
    BibliaLibro(id: 'ezequiel', nombre: 'Ezequiel', abreviatura: 'Ez', testamento: 'Antiguo', totalCapitulos: 48, orden: 26),
    BibliaLibro(id: 'daniel', nombre: 'Daniel', abreviatura: 'Dn', testamento: 'Antiguo', totalCapitulos: 12, orden: 27),
    BibliaLibro(id: 'oseas', nombre: 'Oseas', abreviatura: 'Os', testamento: 'Antiguo', totalCapitulos: 14, orden: 28),
    BibliaLibro(id: 'joel', nombre: 'Joel', abreviatura: 'Jl', testamento: 'Antiguo', totalCapitulos: 3, orden: 29),
    BibliaLibro(id: 'amos', nombre: 'Amós', abreviatura: 'Am', testamento: 'Antiguo', totalCapitulos: 9, orden: 30),
    BibliaLibro(id: 'abdias', nombre: 'Abdías', abreviatura: 'Abd', testamento: 'Antiguo', totalCapitulos: 1, orden: 31),
    BibliaLibro(id: 'jonas', nombre: 'Jonás', abreviatura: 'Jon', testamento: 'Antiguo', totalCapitulos: 4, orden: 32),
    BibliaLibro(id: 'miqueas', nombre: 'Miqueas', abreviatura: 'Miq', testamento: 'Antiguo', totalCapitulos: 7, orden: 33),
    BibliaLibro(id: 'nahum', nombre: 'Nahúm', abreviatura: 'Nah', testamento: 'Antiguo', totalCapitulos: 3, orden: 34),
    BibliaLibro(id: 'habacuc', nombre: 'Habacuc', abreviatura: 'Hab', testamento: 'Antiguo', totalCapitulos: 3, orden: 35),
    BibliaLibro(id: 'sofonias', nombre: 'Sofonías', abreviatura: 'Sof', testamento: 'Antiguo', totalCapitulos: 3, orden: 36),
    BibliaLibro(id: 'hageo', nombre: 'Hageo', abreviatura: 'Hag', testamento: 'Antiguo', totalCapitulos: 2, orden: 37),
    BibliaLibro(id: 'zacarias', nombre: 'Zacarías', abreviatura: 'Zac', testamento: 'Antiguo', totalCapitulos: 14, orden: 38),
    BibliaLibro(id: 'malaquias', nombre: 'Malaquías', abreviatura: 'Mal', testamento: 'Antiguo', totalCapitulos: 4, orden: 39),
    
    // NUEVO TESTAMENTO
    BibliaLibro(id: 'mateo', nombre: 'Mateo', abreviatura: 'Mt', testamento: 'Nuevo', totalCapitulos: 28, orden: 40),
    BibliaLibro(id: 'marcos', nombre: 'Marcos', abreviatura: 'Mc', testamento: 'Nuevo', totalCapitulos: 16, orden: 41),
    BibliaLibro(id: 'lucas', nombre: 'Lucas', abreviatura: 'Lc', testamento: 'Nuevo', totalCapitulos: 24, orden: 42),
    BibliaLibro(id: 'juan', nombre: 'Juan', abreviatura: 'Jn', testamento: 'Nuevo', totalCapitulos: 21, orden: 43),
    BibliaLibro(id: 'hechos', nombre: 'Hechos', abreviatura: 'Hch', testamento: 'Nuevo', totalCapitulos: 28, orden: 44),
    BibliaLibro(id: 'romanos', nombre: 'Romanos', abreviatura: 'Ro', testamento: 'Nuevo', totalCapitulos: 16, orden: 45),
    BibliaLibro(id: '1corintios', nombre: '1 Corintios', abreviatura: '1 Co', testamento: 'Nuevo', totalCapitulos: 16, orden: 46),
    BibliaLibro(id: '2corintios', nombre: '2 Corintios', abreviatura: '2 Co', testamento: 'Nuevo', totalCapitulos: 13, orden: 47),
    BibliaLibro(id: 'galatas', nombre: 'Gálatas', abreviatura: 'Gá', testamento: 'Nuevo', totalCapitulos: 6, orden: 48),
    BibliaLibro(id: 'efesios', nombre: 'Efesios', abreviatura: 'Ef', testamento: 'Nuevo', totalCapitulos: 6, orden: 49),
    BibliaLibro(id: 'filipenses', nombre: 'Filipenses', abreviatura: 'Fil', testamento: 'Nuevo', totalCapitulos: 4, orden: 50),
    BibliaLibro(id: 'colosenses', nombre: 'Colosenses', abreviatura: 'Col', testamento: 'Nuevo', totalCapitulos: 4, orden: 51),
    BibliaLibro(id: '1tesalonicenses', nombre: '1 Tesalonicenses', abreviatura: '1 Ts', testamento: 'Nuevo', totalCapitulos: 5, orden: 52),
    BibliaLibro(id: '2tesalonicenses', nombre: '2 Tesalonicenses', abreviatura: '2 Ts', testamento: 'Nuevo', totalCapitulos: 3, orden: 53),
    BibliaLibro(id: '1timoteo', nombre: '1 Timoteo', abreviatura: '1 Ti', testamento: 'Nuevo', totalCapitulos: 6, orden: 54),
    BibliaLibro(id: '2timoteo', nombre: '2 Timoteo', abreviatura: '2 Ti', testamento: 'Nuevo', totalCapitulos: 4, orden: 55),
    BibliaLibro(id: 'tito', nombre: 'Tito', abreviatura: 'Tit', testamento: 'Nuevo', totalCapitulos: 3, orden: 56),
    BibliaLibro(id: 'filemon', nombre: 'Filemón', abreviatura: 'Flm', testamento: 'Nuevo', totalCapitulos: 1, orden: 57),
    BibliaLibro(id: 'hebreos', nombre: 'Hebreos', abreviatura: 'He', testamento: 'Nuevo', totalCapitulos: 13, orden: 58),
    BibliaLibro(id: 'santiago', nombre: 'Santiago', abreviatura: 'Stg', testamento: 'Nuevo', totalCapitulos: 5, orden: 59),
    BibliaLibro(id: '1pedro', nombre: '1 Pedro', abreviatura: '1 P', testamento: 'Nuevo', totalCapitulos: 5, orden: 60),
    BibliaLibro(id: '2pedro', nombre: '2 Pedro', abreviatura: '2 P', testamento: 'Nuevo', totalCapitulos: 3, orden: 61),
    BibliaLibro(id: '1juan', nombre: '1 Juan', abreviatura: '1 Jn', testamento: 'Nuevo', totalCapitulos: 5, orden: 62),
    BibliaLibro(id: '2juan', nombre: '2 Juan', abreviatura: '2 Jn', testamento: 'Nuevo', totalCapitulos: 1, orden: 63),
    BibliaLibro(id: '3juan', nombre: '3 Juan', abreviatura: '3 Jn', testamento: 'Nuevo', totalCapitulos: 1, orden: 64),
    BibliaLibro(id: 'judas', nombre: 'Judas', abreviatura: 'Jud', testamento: 'Nuevo', totalCapitulos: 1, orden: 65),
    BibliaLibro(id: 'apocalipsis', nombre: 'Apocalipsis', abreviatura: 'Ap', testamento: 'Nuevo', totalCapitulos: 22, orden: 66),
  ];

  // Obtener capítulo desde API
  Future<BibliaCapitulo> getCapitulo(String libroId, int capitulo) async {
    try {
      final bookApiId = _bookIds[libroId];
      if (bookApiId == null) {
        return _getCapituloFallback(libroId, capitulo);
      }

      final chapterId = '$bookApiId.$capitulo';
      final url = '$_baseUrl/bibles/$_bibleId/chapters/$chapterId';

      final response = await http.get(
        Uri.parse('$url?content-type=text&include-notes=false&include-titles=false&include-chapter-numbers=false&include-verse-numbers=true&include-verse-spans=false'),
        headers: {
          'api-key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseCapitulo(data, libroId, capitulo);
      }

      return _getCapituloFallback(libroId, capitulo);
    } catch (e) {
      print('Error cargando capítulo: $e');
      return _getCapituloFallback(libroId, capitulo);
    }
  }

  BibliaCapitulo _parseCapitulo(Map<String, dynamic> data, String libroId, int capitulo) {
    try {
      final content = data['data']['content'] as String;
      final libro = libros.firstWhere((l) => l.id == libroId);
      
      // Parsear el HTML simple
      final versiculos = <BibliaVersiculo>[];
      final regex = RegExp(r'\[(\d+)\]\s*([^\[]+)');
      final matches = regex.allMatches(content);

      for (final match in matches) {
        final numero = int.parse(match.group(1)!);
        var texto = match.group(2)!.trim();
        
        // Limpiar HTML tags
        texto = texto.replaceAll(RegExp(r'<[^>]*>'), '');
        texto = texto.replaceAll('&nbsp;', ' ');
        texto = texto.trim();

        if (texto.isNotEmpty) {
          versiculos.add(BibliaVersiculo(numero: numero, texto: texto));
        }
      }

      return BibliaCapitulo(
        libro: libro.nombre,
        capitulo: capitulo,
        versiculos: versiculos,
      );
    } catch (e) {
      print('Error parseando: $e');
      return _getCapituloFallback(libroId, capitulo);
    }
  }

  BibliaCapitulo _getCapituloFallback(String libroId, int capitulo) {
    final libro = libros.firstWhere((l) => l.id == libroId);
    
    // Datos de ejemplo para Génesis 1
    if (libroId == 'genesis' && capitulo == 1) {
      return BibliaCapitulo(
        libro: libro.nombre,
        capitulo: 1,
        versiculos: [
          BibliaVersiculo(numero: 1, texto: 'EN el principio crió Dios los cielos y la tierra.'),
          BibliaVersiculo(numero: 2, texto: 'Y la tierra estaba desordenada y vacía, y las tinieblas estaban sobre la haz del abismo, y el Espíritu de Dios se movía sobre la haz de las aguas.'),
          BibliaVersiculo(numero: 3, texto: 'Y dijo Dios: Sea la luz: y fué la luz.'),
          BibliaVersiculo(numero: 4, texto: 'Y vió Dios que la luz era buena: y apartó Dios la luz de las tinieblas.'),
          BibliaVersiculo(numero: 5, texto: 'Y llamó Dios á la luz Día, y á las tinieblas llamó Noche: y fué la tarde y la mañana un día.'),
        ],
      );
    }

    return BibliaCapitulo(
      libro: libro.nombre,
      capitulo: capitulo,
      versiculos: [
        BibliaVersiculo(
          numero: 1,
          texto: 'Contenido no disponible. Por favor verifica tu conexión a internet.',
        ),
      ],
    );
  }

  static List<BibliaLibro> getLibrosByTestamento(String testamento) {
    return libros.where((l) => l.testamento == testamento).toList();
  }

  static BibliaLibro? getLibroById(String id) {
    try {
      return libros.firstWhere((l) => l.id == id);
    } catch (e) {
      return null;
    }
  }
}