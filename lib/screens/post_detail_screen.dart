import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../models/post_model.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTipoBadge(),
                _buildHeader(),
                
                if (post.detalleCompleto != null)
                  _buildDetailDescription(),
                
                if (post.horarios != null && post.horarios!.isNotEmpty)
                  _buildHorarios(),
                
                if (post.ubicaciones != null && post.ubicaciones!.isNotEmpty)
                  _buildUbicaciones(),
                
                if (post.costo != null)
                  _buildCosto(),
                
                if (post.hashtags != null && post.hashtags!.isNotEmpty)
                  _buildHashtags(),
                
                if (post.enlaceWeb != null)
                  _buildEnlaceWeb(),
                
                const SizedBox(height: 24),
                
                if (post.permitirCompartir)
                  _buildShareButton(context),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: const Color(0xFF1A1A1A),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (post.permitirCompartir)
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.share, color: Colors.white),
            ),
            onPressed: () => _sharePost(context),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: post.imagenUrl != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                color: const Color(0xFFB8956A),
                child: const Center(
                  child: Icon(
                    Icons.event,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = kIsWeb && post.imagenUrl != null
        ? (post.imagenUrl!.contains('unsplash.com') ||
                post.imagenUrl!.contains('firebasestorage.googleapis.com')
            ? post.imagenUrl!
            : 'https://corsproxy.io/?${Uri.encodeComponent(post.imagenUrl!)}')
        : post.imagenUrl!;

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFFB8956A),
          child: const Center(
            child: Icon(Icons.event, size: 80, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildTipoBadge() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getTipoColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getTipoIcon(),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 6),
          Text(
            post.tipo.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.fechaEvento != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2D5F6F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEEE d \'de\' MMMM \'de\' y', 'es')
                        .format(post.fechaEvento!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          
          Text(
            post.titulo,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5F6F),
              height: 1.2,
            ),
          ),
          
          if (post.subtitulo != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                post.subtitulo!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFFB8956A),
                child: const Icon(Icons.home, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.autor,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Publicado ${_getTimeAgo(post.fechaPublicacion)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailDescription() {
    String text = post.detalleCompleto!
        .replaceAll('\\n', '\n')
        .replaceAll('\n\n\n', '\n\n')
        .trim();
    
    List<String> lines = text.split('\n');
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lines.map((line) {
            if (line.trim().isEmpty) {
              return const SizedBox(height: 8);
            }
            
            if (line.trim().startsWith('#')) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  line,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2D5F6F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
            
            if (line.contains('"') || line.startsWith('✨') || line.startsWith('📖')) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  line,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              );
            }
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                line,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHorarios() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.access_time, color: Color(0xFF2D5F6F), size: 20),
              SizedBox(width: 8),
              Text(
                'Horarios',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D5F6F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...post.horarios!.map((horario) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFB8956A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, color: Color(0xFFB8956A), size: 20),
                    const SizedBox(width: 12),
                    Text(
                      horario,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildUbicaciones() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFF2D5F6F), size: 20),
              SizedBox(width: 8),
              Text(
                'Ubicaciones',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D5F6F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...post.ubicaciones!.map((ubicacion) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2D5F6F), Color(0xFF3A7A8C)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.church, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        ubicacion,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCosto() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFB8956A).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFB8956A)),
        ),
        child: Row(
          children: [
            const Icon(Icons.confirmation_number, color: Color(0xFFB8956A)),
            const SizedBox(width: 12),
            const Text(
              'Costo: ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              post.costo!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D5F6F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHashtags() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: post.hashtags!.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2D5F6F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '#$tag',
                style: const TextStyle(
                  color: Color(0xFF2D5F6F),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            )).toList(),
      ),
    );
  }

  Widget _buildEnlaceWeb() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue),
          ),
          child: Row(
            children: [
              const Icon(Icons.link, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  post.enlaceWeb!,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _sharePost(context),
          icon: const Icon(Icons.share),
          label: const Text('Compartir evento'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D5F6F),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  void _sharePost(BuildContext context) async {
  String shareText = '';
  
  shareText += '${post.titulo}\n';
  if (post.subtitulo != null) {
    shareText += '${post.subtitulo}\n';
  }
  shareText += '\n';
  
  if (post.fechaEvento != null) {
    shareText += '📅 ${DateFormat('EEEE d \'de\' MMMM \'de\' y', 'es').format(post.fechaEvento!)}\n\n';
  }
  
  if (post.detalleCompleto != null) {
    shareText += '${post.detalleCompleto}\n\n';
  } else if (post.descripcion != null) {
    shareText += '${post.descripcion}\n\n';
  }
  
  if (post.horarios != null && post.horarios!.isNotEmpty) {
    shareText += '⏰ Horarios:\n';
    for (var horario in post.horarios!) {
      shareText += '• $horario\n';
    }
    shareText += '\n';
  }
  
  if (post.ubicaciones != null && post.ubicaciones!.isNotEmpty) {
    shareText += '📍 Ubicaciones:\n';
    for (var ubicacion in post.ubicaciones!) {
      shareText += '• $ubicacion\n';
    }
    shareText += '\n';
  }
  
  if (post.costo != null) {
    shareText += '💰 Costo: ${post.costo}\n\n';
  }
  
  if (post.hashtags != null && post.hashtags!.isNotEmpty) {
    shareText += post.hashtags!.map((tag) => '#$tag').join(' ') + '\n\n';
  }
  
  if (post.enlaceWeb != null) {
    shareText += '🔗 ${post.enlaceWeb}\n';
  }
  
  try {
    // Usar Share.share en lugar de Share.shareWithResult
    await Share.share(
      shareText.trim(),
      subject: post.titulo,
    );
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compartido'),
          backgroundColor: Color(0xFF2D5F6F),
          duration: Duration(seconds: 1),
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 7) {
      return 'el ${DateFormat('d MMM', 'es').format(date)}';
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
        return '📅';
      case 'video':
        return '🎥';
      case 'anuncio':
        return '📢';
      default:
        return '📄';
    }
  }

  Color _getTipoColor() {
    switch (post.tipo.toLowerCase()) {
      case 'evento':
        return const Color(0xFF2D5F6F);
      case 'video':
        return Colors.red;
      case 'anuncio':
        return const Color(0xFFB8956A);
      default:
        return Colors.grey;
    }
  }
}