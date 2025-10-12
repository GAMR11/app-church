import 'package:flutter/material.dart';
import '../widgets/sobre_tab.dart';
import '../widgets/equipo_tab.dart'; // Agregar este import

class IglesiaScreen extends StatelessWidget {
  const IglesiaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Iglesia Nazareno Pacará',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.mail_outline, color: Colors.white),
              onPressed: () {
                // Acción de mensajes
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF2D5F6F),
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.info_outline, size: 20),
                    text: 'Sobre',
                  ),
                  Tab(
                    icon: Icon(Icons.people_outline, size: 20),
                    text: 'Equipo',
                  ),
                  Tab(
                    icon: Icon(Icons.volunteer_activism, size: 20),
                    text: 'Donar',
                  ),
                  Tab(
                    icon: Icon(Icons.church, size: 20),
                    text: 'Ministerios',
                  ),
                  Tab(
                    icon: Icon(Icons.school, size: 20),
                    text: 'Academia',
                  ),
                  Tab(
                    icon: Icon(Icons.event, size: 20),
                    text: 'Eventos',
                  ),
                  Tab(
                    icon: Icon(Icons.access_time, size: 20),
                    text: 'Asesoramiento',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            SobreTab(),
            EquipoTab(), // ← Cambiar aquí
            // _PlaceholderTab(title: 'Equipo'),
            _PlaceholderTab(title: 'Donar'),
            _PlaceholderTab(title: 'Ministerios'),
            _PlaceholderTab(title: 'Academia'),
            _PlaceholderTab(title: 'Eventos'),
            _PlaceholderTab(title: 'Asesoramiento'),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;

  const _PlaceholderTab({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '$title\n(En desarrollo)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}