import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import '../models/church_info_model.dart';
import '../services/church_service.dart';

class SobreTab extends StatefulWidget {
  const SobreTab({Key? key}) : super(key: key);

  @override
  State<SobreTab> createState() => _SobreTabState();
}

class _SobreTabState extends State<SobreTab> {
  final ChurchService _churchService = ChurchService();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay(int imageCount) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < imageCount - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChurchInfo?>(
      stream: _churchService.getChurchInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('No se encontró información de la iglesia'),
          );
        }

        final churchInfo = snapshot.data!;

        // Iniciar autoplay con el número correcto de imágenes
        if (_timer == null && churchInfo.imagenesCarrusel.isNotEmpty) {
          _startAutoPlay(churchInfo.imagenesCarrusel.length);
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBannerCarousel(churchInfo.imagenesCarrusel),
              // _buildChurchName(churchInfo.nombre, churchInfo.slogan),
              // _buildDescription(churchInfo.descripcion),
              // _buildContactInfo(churchInfo),
              _buildSocialMedia(churchInfo.redesSociales),
              _buildHorarios(churchInfo.horarios),
              _buildQuienesSomos(churchInfo.quienesSomos),
              _buildMision(churchInfo.mision),
              _buildVision(churchInfo.vision),
              _buildValores(churchInfo.valores, churchInfo.valoresTexto, churchInfo.ubicaciones),
              _buildDeclaracionFe(churchInfo.declaracionFe),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBannerCarousel(List<String> images) {
    if (images.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.church, size: 64, color: Colors.grey),
        ),
      );
    }

    return Container(
      height: 250,
      color: Colors.grey[200],
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              return _buildImage(images[index]);
            },
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    final processedUrl = kIsWeb
        ? (imageUrl.contains('unsplash.com') ||
                imageUrl.contains('firebasestorage.googleapis.com')
            ? imageUrl
            : 'https://corsproxy.io/?${Uri.encodeComponent(imageUrl)}')
        : imageUrl;

    return Image.network(
      processedUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.church, size: 64, color: Colors.grey),
          ),
        );
      },
    );
  }

  // Widget _buildChurchName(String nombre, String slogan) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(24),
  //     child: Column(
  //       children: [
  //         Text(
  //           nombre,
  //           style: const TextStyle(
  //             fontSize: 32,
  //             fontWeight: FontWeight.bold,
  //             color: Color(0xFF2D5F6F),
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           slogan,
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.grey[600],
  //             height: 1.5,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildDescription(String descripcion) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     child: Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Colors.grey[50],
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Text(
  //         descripcion,
  //         style: const TextStyle(
  //           fontSize: 15,
  //           height: 1.6,
  //           color: Colors.black87,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildContactInfo(ChurchInfo churchInfo) {
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       children: [
  //         _buildContactItem(Icons.link, churchInfo.sitioWeb, Colors.blue),
  //         _buildContactItem(Icons.email, churchInfo.email, Colors.red),
  //         _buildContactItem(Icons.phone, churchInfo.telefono, Colors.green),
  //         if (churchInfo.telefono2 != null)
  //           _buildContactItem(Icons.phone, churchInfo.telefono2!, Colors.green),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildContactItem(IconData icon, String text, Color color) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 12),
  //     child: Row(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             color: color.withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Icon(icon, color: color, size: 20),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Text(
  //             text,
  //             style: TextStyle(fontSize: 14, color: Colors.grey[800]),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSocialMedia(Map<String, String> redesSociales) {
    final Map<String, Map<String, dynamic>> socialConfig = {
      'facebook': {'icon': Icons.facebook, 'color': const Color(0xFF1877F2)},
      'instagram': {'icon': Icons.camera_alt, 'color': const Color(0xFFE4405F)},
      'youtube': {
        'icon': Icons.smart_display,
        'color': const Color(0xFFFF0000)
      },
      'appleMusic': {
        'icon': Icons.music_note,
        'color': const Color(0xFFFA243C)
      },
      'telegram': {'icon': Icons.telegram, 'color': const Color(0xFF0088CC)},
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: redesSociales.entries.map((entry) {
          final config = socialConfig[entry.key];
          if (config == null) return const SizedBox.shrink();

          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: config['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              config['icon'],
              color: config['color'],
              size: 28,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHorarios(List<HorarioServicio> horarios) {
    return _buildSection(
      title: 'Servicio',
      children: horarios.map((horario) {
        return _buildHorarioItem(dia: horario.dia, items: horario.servicios);
      }).toList(),
    );
  }

  Widget _buildHorarioItem({required String dia, required List<String> items}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dia,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5F6F),
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildQuienesSomos(String quienesSomos) {
    return _buildSection(
      title: 'Quiénes somos',
      children: [_buildTextContent(quienesSomos)],
    );
  }

  Widget _buildMision(MisionVision mision) {
    return _buildSection(
      title: mision.titulo,
      subtitle: mision.subtitulo,
      children: [
        if (mision.versiculo1 != null)
          _buildBibleQuote(
              mision.versiculo1!.texto, mision.versiculo1!.referencia),
        if (mision.versiculo1 != null && mision.versiculo2 != null)
          const SizedBox(height: 16),
        if (mision.versiculo2 != null) ...[
          _buildTextContent(mision.versiculo2!.texto),
          _buildBibleReference(mision.versiculo2!.referencia),
        ],
      ],
    );
  }

  Widget _buildVision(MisionVision vision) {
    return _buildSection(
      title: vision.titulo,
      subtitle: vision.subtitulo,
      children: [
        if (vision.versiculo != null)
          _buildBibleQuote(
              vision.versiculo!.texto, vision.versiculo!.referencia),
        if (vision.inspiracion != null) ...[
          const SizedBox(height: 16),
          _buildTextContent(vision.inspiracion!),
        ],
        if (vision.puntos != null) ...[
          const SizedBox(height: 12),
          ...vision.puntos!.map((punto) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildTextContent(punto),
              )),
        ],
      ],
    );
  }

  Widget _buildValores(
      List<String> valores, String valoresTexto, List<Ubicacion> ubicaciones) {
    return _buildSection(
      title: 'Nuestros valores:',
      children: [
        ...valores.map((valor) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child:
                        Icon(Icons.circle, size: 8, color: Color(0xFF2D5F6F)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      valor,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 12),
        _buildTextContent(valoresTexto),
        const SizedBox(height: 16),
        _buildTextContent('Nos reunimos de manera presencial en:'),
        const SizedBox(height: 12),
        ...ubicaciones.map((ubicacion) =>
            _buildLocationItem(ubicacion.nombre, ubicacion.direccion)),
      ],
    );
  }

  Widget _buildDeclaracionFe(List<String> declaraciones) {
    return _buildSection(
      title: 'Declaración de fe',
      children: declaraciones
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 15, height: 1.6),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSection({
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5F6F),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextContent(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        height: 1.6,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildBibleQuote(String quote, String reference) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D5F6F).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2D5F6F).withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quote,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            reference,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5F6F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBibleReference(String reference) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        reference,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D5F6F),
        ),
      ),
    );
  }

  Widget _buildLocationItem(String title, String address) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5F6F),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            address,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
