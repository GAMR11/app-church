import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/team_member_model.dart';
import '../services/team_service.dart';
import '../screens/team_member_detail_screen.dart';

class EquipoTab extends StatefulWidget {
  const EquipoTab({Key? key}) : super(key: key);

  @override
  State<EquipoTab> createState() => _EquipoTabState();
}

class _EquipoTabState extends State<EquipoTab> {
  final TeamService _teamService = TeamService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TeamMember>>(
      stream: _teamService.getTeamMembers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No hay miembros registrados'),
          );
        }

        final members = snapshot.data!;

        // Agrupar por rol
        final Map<String, List<TeamMember>> membersByRole = {};
        for (var member in members) {
          if (!membersByRole.containsKey(member.rol)) {
            membersByRole[member.rol] = [];
          }
          membersByRole[member.rol]!.add(member);
        }

        return ListView(
          children: membersByRole.entries.map((entry) {
            return _buildRoleSection(entry.key, entry.value);
          }).toList(),
        );
      },
    );
  }

  Widget _buildRoleSection(String role, List<TeamMember> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título del rol
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.grey[100],
          child: Text(
            role,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5F6F),
            ),
          ),
        ),
        // Lista de miembros
        ...members.map((member) => _buildMemberCard(member)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildMemberCard(TeamMember member) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeamMemberDetailScreen(member: member),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            // Imagen circular
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildMemberImage(member.imagenUrl),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.cargo,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Botón "Abrir"
            Text(
              'Abrir',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberImage(String imageUrl) {
    final processedUrl = kIsWeb
        ? (imageUrl.contains('unsplash.com') ||
                imageUrl.contains('firebasestorage.googleapis.com')
            ? imageUrl
            : 'https://corsproxy.io/?${Uri.encodeComponent(imageUrl)}')
        : imageUrl;

    return Image.network(
      processedUrl,
      width: 70,
      height: 70,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 70,
          height: 70,
          color: Colors.grey[300],
          child: const Icon(Icons.person, size: 40, color: Colors.grey),
        );
      },
    );
  }
}