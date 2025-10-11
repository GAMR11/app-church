import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import '../models/post_model.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con avatar y autor
          _buildHeader(),
          
          // Imagen principal si existe
          if (post.imagenUrl != null) _buildImage(),
          
          // Información del evento
          _buildEventInfo(),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    String timeAgo = _getTimeAgo(post.fechaPublicacion);
    
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFB8956A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.home,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          
          // Autor y fecha
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.autor,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '• ${_getTipoIcon()}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Image.network(
      post.imagenUrl!,
      width: double.infinity,
      height: 300,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: 300,
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
        print('URL: ${post.imagenUrl}');
        return Container(
          height: 300,
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
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  error.toString(),
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fecha del evento si existe
          if (post.fechaEvento != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D5F6F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('d').format(post.fechaEvento!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('MMM', 'es').format(post.fechaEvento!).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      post.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D5F6F),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            // Si no hay fecha de evento, solo mostrar título
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                post.titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          
          // Subtítulo si existe
          if (post.subtitulo != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                post.subtitulo!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          
          // Descripción si existe
          if (post.descripcion != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                post.descripcion!,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          
          // Horarios y ubicaciones
          if (post.ubicaciones != null && post.ubicaciones!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...post.ubicaciones!.map((ubicacion) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      ubicacion,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 7) {
      return DateFormat('d MMM', 'es').format(date);
    } else if (difference.inDays > 0) {
      return 'hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'ahora';
    }
  }

  String _getTipoIcon() {
    switch (post.tipo.toLowerCase()) {
      case 'evento':
        return '📅 Evento';
      case 'video':
        return '🎥 Video';
      case 'anuncio':
        return '📢 Anuncio';
      default:
        return post.tipo;
    }
  }
}