// Este es el archivo principal de tu aplicación Flutter (Dart).
import 'package:flutter/material.dart';

// Eliminamos todos los imports de Firebase (cloud_firestore, firebase_core)
// y quitamos la inicialización de main.

void main() {
  runApp(const AppIglesia());
}

// 2. Widget principal (Stateless: no cambia)
class AppIglesia extends StatelessWidget {
  const AppIglesia({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iglesia App',
      theme: ThemeData(
        primarySwatch: Colors.indigo, // Color principal
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      // Ya no necesitamos el FutureBuilder, cargamos la PantallaPrincipal directamente.
      home: const PantallaPrincipal(),
    );
  }
}

// 3. Pantalla principal (Stateful: puede cambiar de pestaña)
class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _indiceSeleccionado = 0;

  // Lista de Widgets (pantallas) que se mostrarán en el cuerpo (body).
  static const List<Widget> _opcionesPantalla = <Widget>[
    PaginaInicio(titulo: 'Inicio - Visión'),
    PaginaVideos(), // Pantalla con TabBar (Videos, Fotos, Blog)
    PaginaEventos(titulo: 'Eventos y Noticias'), // Eventos
    PaginaContacto(titulo: 'Contacto y Ubicación'),
  ];

  void _alTocarItem(int index) {
    setState(() {
      _indiceSeleccionado = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iglesia App Estática'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
      ),
      body: _opcionesPantalla.elementAt(_indiceSeleccionado),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, 
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ondemand_video), 
            label: 'Media',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contacto',
          ),
        ],
        currentIndex: _indiceSeleccionado,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _alTocarItem,
      ),
    );
  }
}

// --- WIDGETS DE PÁGINAS PRINCIPALES ---

class PaginaInicio extends StatelessWidget {
  final String titulo;
  const PaginaInicio({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(titulo, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.indigo.shade100,
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: NetworkImage('https://placehold.co/600x200/4F46E5/FFFFFF?text=Imagen+de+la+Iglesia'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mensaje de Bienvenida', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.indigo)),
                    const SizedBox(height: 10),
                    const Text(
                      '¡Estamos felices de que estés aquí! Nuestro deseo es compartir la Palabra y servir a la comunidad. Revisa la sección de Eventos para conocer nuestras próximas actividades.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// --- WIDGET CON TABBAR (MENÚ SUPERIOR) ---
class PaginaVideos extends StatelessWidget {
  const PaginaVideos({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController maneja el estado de las pestañas
    return DefaultTabController(
      length: 4, // 4 Pestañas: Videos, Fotos, Biblioteca, Blog
      child: Column(
        children: <Widget>[
          // El TabBar se coloca justo debajo del AppBar (dentro del cuerpo)
          Container(
            color: Colors.white, // Fondo del TabBar
            child: TabBar(
              isScrollable: true, // Permite deslizar si hay muchas pestañas
              indicatorColor: Theme.of(context).primaryColor, // Indicador azul
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(icon: Icon(Icons.play_circle), text: 'Videos'),
                Tab(icon: Icon(Icons.photo_library), text: 'Fotos'),
                Tab(icon: Icon(Icons.book), text: 'Biblioteca'),
                Tab(icon: Icon(Icons.article), text: 'Blog'),
              ],
            ),
          ),
          // El TabBarView muestra el contenido de cada pestaña
          Expanded(
            child: TabBarView(
              children: [
                // 1. PESTAÑA VIDEOS (Usamos la lista estática)
                _ContenidoListaEstatica(
                  titulo: 'Últimos Mensajes (Simulado)',
                  icono: Icons.play_circle_fill,
                ),
                // 2. PESTAÑA FOTOS 
                _ContenidoListaEstatica(
                  titulo: 'Galería de Fotos (Simulada)',
                  icono: Icons.image,
                ),
                // 3. PESTAÑA BIBLIOTECA 
                const Center(child: Text("Contenido de Biblioteca Estático")),
                // 4. PESTAÑA BLOG 
                const Center(child: Text("Contenido de Blog Estático")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget auxiliar para crear una lista con datos fijos (sin Firebase)
class _ContenidoListaEstatica extends StatelessWidget {
  final String titulo;
  final IconData icono;

  const _ContenidoListaEstatica({required this.titulo, required this.icono});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo
    final List<Map<String, String>> datosEjemplo = [
      {'nombre': 'Sermón: El Reto de la Fe', 'fecha': '01/01/2025'},
      {'nombre': 'Estudio Bíblico: Profecía', 'fecha': '08/01/2025'},
      {'nombre': 'Conferencia: Despertando Familias', 'fecha': '15/01/2025'},
      {'nombre': 'Testimonio de Sanación', 'fecha': '22/01/2025'},
      {'nombre': 'Especial de Adoración', 'fecha': '29/01/2025'},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            titulo,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        // ListView.builder con los datos estáticos
        Expanded(
          child: ListView.builder(
            itemCount: datosEjemplo.length,
            itemBuilder: (context, index) {
              final item = datosEjemplo[index];
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 1,
                child: ListTile(
                  leading: Icon(icono, color: Theme.of(context).primaryColor),
                  title: Text(item['nombre']!), 
                  subtitle: Text(item['fecha']!),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navegación simulada a la pantalla de detalles
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaginaDetalleEstatica(
                          tituloDetalle: item['nombre']!, 
                          fechaDetalle: item['fecha']!,
                          tipo: titulo.contains('Mensajes') ? 'Video' : 'Foto',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Widget CLAVE: Página de Lista de EVENTOS (ahora también estática)
class PaginaEventos extends StatelessWidget {
  final String titulo;
  const PaginaEventos({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    // Reutilizamos el widget auxiliar estático para los eventos.
    return const _ContenidoListaEstatica(
      titulo: 'Próximos Eventos y Anuncios (Simulado)',
      icono: Icons.calendar_month,
    );
  }
}

// Pantalla de Detalle Genérica Estática
class PaginaDetalleEstatica extends StatelessWidget {
  final String tituloDetalle;
  final String fechaDetalle;
  final String tipo; // Para diferenciar si es Video, Foto o Evento

  const PaginaDetalleEstatica({
    super.key, 
    required this.tituloDetalle,
    required this.fechaDetalle,
    required this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tituloDetalle),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$tipo: $tituloDetalle',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Fecha: $fechaDetalle',
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              const Divider(height: 30),
              Text(
                'Contenido Detallado:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              const Text(
                'Aquí se mostraría la descripción completa, el video embebido (si es un video), o una imagen grande (si es una foto o evento).',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Simular una acción de compartir
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Compartiendo $tituloDetalle...')),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Compartir'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    backgroundColor: Colors.indigo.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class PaginaContacto extends StatelessWidget {
  final String titulo;
  const PaginaContacto({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(titulo, 
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 30),
            // Un widget para simular un mapa.
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400)
              ),
              alignment: Alignment.center,
              child: const Text('Mapa (Ubicación simulada)'),
            ),
            const SizedBox(height: 20),
            const Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.location_on, color: Colors.red),
                title: Text('Dirección Principal'),
                subtitle: Text('Calle Falsa 123, Ciudad de la Fe'),
              ),
            ),
            const Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.phone, color: Colors.green),
                title: Text('Teléfono'),
                subtitle: Text('+1 (555) 123-4567'),
              ),
            ),
            const Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.mail, color: Colors.blue),
                title: Text('Correo Electrónico'),
                subtitle: Text('contacto@iglesia.org'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
