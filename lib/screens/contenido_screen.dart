import 'package:flutter/material.dart';
import '../widgets/videos_tab.dart';
import '../widgets/playlist_tab.dart';
import '../widgets/fotos_tab.dart';

class ContenidoScreen extends StatelessWidget {
  const ContenidoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Iglesia Nazareno Pucará',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.mail_outline, color: Colors.white),
              onPressed: () {},
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
                tabs: const [
                  Tab(
                    icon: Icon(Icons.play_circle_outline, size: 20),
                    text: 'Videos',
                  ),
                  Tab(
                    icon: Icon(Icons.music_note, size: 20),
                    text: 'Playlist',
                  ),
                  Tab(
                    icon: Icon(Icons.photo_library, size: 20),
                    text: 'Fotos',
                  ),
                  Tab(
                    icon: Icon(Icons.menu_book, size: 20),
                    text: 'Biblioteca',
                  ),
                  Tab(
                    icon: Icon(Icons.wb_sunny, size: 20),
                    text: 'Devocionales',
                  ),
                  Tab(
                    icon: Icon(Icons.article, size: 20),
                    text: 'Artículos',
                  ),
                  Tab(
                    icon: Icon(Icons.newspaper, size: 20),
                    text: 'Noticias',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            VideosTab(),
            PlaylistTab(),
            FotosTab(),
            _PlaceholderTab(title: 'Biblioteca'),
            _PlaceholderTab(title: 'Devocionales'),
            _PlaceholderTab(title: 'Artículos'),
            _PlaceholderTab(title: 'Noticias'),
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
          Icon(Icons.construction, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '$title\n(En desarrollo)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}