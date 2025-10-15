import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/album_model.dart';

class AlbumDetailScreen extends StatelessWidget {
  final Album album;

  const AlbumDetailScreen({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          album.titulo,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(2),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: album.fotos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _openFullscreen(context, index),
            child: _buildPhotoThumbnail(album.fotos[index]),
          );
        },
      ),
    );
  }

  Widget _buildPhotoThumbnail(String photoUrl) {
    final processedUrl = kIsWeb
        ? (photoUrl.contains('firebasestorage.googleapis.com') ||
                photoUrl.contains('unsplash.com')
            ? photoUrl
            : 'https://corsproxy.io/?${Uri.encodeComponent(photoUrl)}')
        : photoUrl;

    return Image.network(
      processedUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[900],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[900],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  void _openFullscreen(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullscreenGallery(
          fotos: album.fotos,
          initialIndex: initialIndex,
          titulo: album.titulo,
        ),
      ),
    );
  }
}

class _FullscreenGallery extends StatefulWidget {
  final List<String> fotos;
  final int initialIndex;
  final String titulo;

  const _FullscreenGallery({
    required this.fotos,
    required this.initialIndex,
    required this.titulo,
  });

  @override
  State<_FullscreenGallery> createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<_FullscreenGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          '${_currentIndex + 1} / ${widget.fotos.length}',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.fotos.length,
        itemBuilder: (context, index) {
          return _buildFullscreenPhoto(widget.fotos[index]);
        },
      ),
    );
  }

  Widget _buildFullscreenPhoto(String photoUrl) {
    final processedUrl = kIsWeb
        ? (photoUrl.contains('firebasestorage.googleapis.com') ||
                photoUrl.contains('unsplash.com')
            ? photoUrl
            : 'https://corsproxy.io/?${Uri.encodeComponent(photoUrl)}')
        : photoUrl;

    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: Image.network(
          processedUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.broken_image, color: Colors.white, size: 64),
            );
          },
        ),
      ),
    );
  }
}