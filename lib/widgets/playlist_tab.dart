import 'package:flutter/material.dart';

class PlaylistTab extends StatelessWidget {
  const PlaylistTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Playlist\n(En desarrollo)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}