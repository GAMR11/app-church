import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class CorsImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CorsImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  String _getCorsProxyUrl(String url) {
    // Usar proxy CORS solo en web
    if (kIsWeb) {
      // Opción 1: allOrigins proxy
      return 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(url)}';
      
      // Opción 2: corsproxy.io (alternativa)
      // return 'https://corsproxy.io/?${Uri.encodeComponent(url)}';
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final processedUrl = _getCorsProxyUrl(imageUrl);

    return Image.network(
      processedUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height ?? 300,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: const Color(0xFFB8956A),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        print('Error cargando imagen: $error');
        print('URL original: $imageUrl');
        print('URL procesada: $processedUrl');
        return Container(
          width: width,
          height: height ?? 300,
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.broken_image,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                'Error al cargar imagen',
                style: TextStyle(color: Colors.grey[600]),
              ),
              if (kIsWeb)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Problema de CORS',
                    style: TextStyle(fontSize: 10, color: Colors.red),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}