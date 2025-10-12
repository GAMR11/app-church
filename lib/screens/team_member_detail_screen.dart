import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/team_member_model.dart';

class TeamMemberDetailScreen extends StatelessWidget {
  final TeamMember member;

  const TeamMemberDetailScreen({Key? key, required this.member})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Perfil',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Imagen del miembro
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildImage(),
          ),
          const SizedBox(height: 16),
          // Nombre
          Text(
            member.nombre,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5F6F),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = kIsWeb
        ? (member.imagenUrl.contains('unsplash.com') ||
                member.imagenUrl.contains('firebasestorage.googleapis.com')
            ? member.imagenUrl
            : 'https://corsproxy.io/?${Uri.encodeComponent(member.imagenUrl)}')
        : member.imagenUrl;

    return Image.network(
      imageUrl,
      width: 200,
      height: 200,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 200,
          height: 200,
          color: Colors.grey[300],
          child: const Icon(Icons.person, size: 80, color: Colors.grey),
        );
      },
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Función / Posición
          _buildSection(
            title: 'Función / Posición:',
            content: member.cargo,
          ),

          const SizedBox(height: 24),

          // Descripción
          _buildSection(
            title: 'Descripción:',
            content: member.descripcion,
          ),

          // Fecha de ordenación (si existe)
          if (member.fechaOrdenacion != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2D5F6F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF2D5F6F),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Ordenado desde: ${member.fechaOrdenacion}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D5F6F),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Contacto (si existe)
          if (member.telefono != null || member.email != null) ...[
            const SizedBox(height: 24),
            const Text(
              'Contacto:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D5F6F),
              ),
            ),
            const SizedBox(height: 12),
            if (member.telefono != null)
              _buildContactItem(
                Icons.phone,
                member.telefono!,
                Colors.green,
              ),
            if (member.email != null)
              _buildContactItem(
                Icons.email,
                member.email!,
                Colors.red,
              ),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D5F6F),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}