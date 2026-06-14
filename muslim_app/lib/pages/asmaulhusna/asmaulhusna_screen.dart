import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../providers/asmaul_husna_provider.dart';
import '../../services/db_helper.dart';
import '../../theme/colors.dart';

class AsmaulHusnaScreen extends StatefulWidget {
  const AsmaulHusnaScreen({super.key});

  @override
  State<AsmaulHusnaScreen> createState() => _AsmaulHusnaScreenState();
}

class _AsmaulHusnaScreenState extends State<AsmaulHusnaScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingIndex;
  List<int> _favoriteIds = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if(mounted) Provider.of<AsmaulHusnaProvider>(context, listen: false).fetchAsmaulHusna();
      _loadFavorites();
    });
    DbHelper.instance.addListener(_loadFavorites);

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _playingIndex = null;
        });
      }
    });
  }

  Future<void> _loadFavorites() async {
    final favorites = await DbHelper.instance.queryAllFavorites();
    setState(() {
      _favoriteIds = favorites
          .where((f) => f['type'] == 'asmaul_husna')
          .map((f) => f['itemId'] as int)
          .toList();
    });
  }

  Future<void> _toggleFavorite(AsmaulHusna item) async {
    if (_favoriteIds.contains(item.id)) {
      final favorites = await DbHelper.instance.queryAllFavorites();
      final fav = favorites.firstWhere(
        (f) => f['type'] == 'asmaul_husna' && f['itemId'] == item.id,
      );
      await DbHelper.instance.deleteFavorite(fav['id']);
      setState(() {
        _favoriteIds.remove(item.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dihapus dari favorit')));
      }
    } else {
      await DbHelper.instance.insertFavorite({
        'type': 'asmaul_husna',
        'itemId': item.id,
        'title': item.latin,
        'subtitle': item.meaning,
      });
      setState(() {
        _favoriteIds.add(item.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ditambahkan ke favorit')));
      }
    }
  }

  @override
  void dispose() {
    DbHelper.instance.removeListener(_loadFavorites);
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio(int index, int id) async {
    if (_playingIndex == index) {
      await _audioPlayer.stop();
      setState(() => _playingIndex = null);
    } else {
      setState(() => _playingIndex = index);
      // Constructing URL for the audio based on ID. 
      // Replace with your actual audio source if different.
      String audioUrl = 'https://equran.nos.wjv-1.neo.id/audio-asmaul-husna/0${id < 10 ? '0$id' : id}.mp3';
      if (id >= 100) {
        audioUrl = 'https://equran.nos.wjv-1.neo.id/audio-asmaul-husna/$id.mp3';
      }
      
      try {
        await _audioPlayer.play(UrlSource(audioUrl));
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memutar audio')));
        }
        setState(() => _playingIndex = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asmaul Husna')),
      body: Consumer<AsmaulHusnaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }
          if (provider.asmaulHusnaList.isEmpty) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.80,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: provider.asmaulHusnaList.length,
            itemBuilder: (context, index) {
              final item = provider.asmaulHusnaList[index];
              final isPlaying = _playingIndex == index;
              final isFavorite = _favoriteIds.contains(item.id);
              
              return Card(
                elevation: 0,
                color: isPlaying ? AppColors.primary.withOpacity(0.1) : Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: isPlaying ? AppColors.primary : AppColors.primary.withOpacity(0.2), width: 1),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _playAudio(index, item.id),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${item.id}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.arabic,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Uthmani', // Assuming you have an Arabic font
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.latin,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.meaning,
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (isPlaying)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: const Icon(Icons.volume_up, color: AppColors.primary, size: 16)
                              .animate(onPlay: (controller) => controller.repeat(reverse: true))
                              .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
                        ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.redAccent : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => _toggleFavorite(item),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.9, 0.9));
            },
          ).animate().fadeIn(duration: 300.ms);
        },
      ),
    );
  }
}
