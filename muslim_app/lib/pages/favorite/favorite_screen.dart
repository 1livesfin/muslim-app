import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../services/db_helper.dart';
import '../../theme/colors.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshFavorites();
    DbHelper.instance.addListener(_refreshFavorites);
  }

  @override
  void dispose() {
    DbHelper.instance.removeListener(_refreshFavorites);
    super.dispose();
  }

  Future<void> _refreshFavorites() async {
    final data = await DbHelper.instance.queryAllFavorites();
    setState(() {
      _favorites = data;
      _isLoading = false;
    });
  }

  Future<void> _removeFavorite(int id) async {
    await DbHelper.instance.deleteFavorite(id);
    _refreshFavorites();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dihapus dari favorit')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 80, color: Colors.grey.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text('Belum ada favorit', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                    ],
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final item = _favorites[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Icon(
                            item['type'] == 'surah'
                                ? Icons.menu_book
                                : item['type'] == 'doa'
                                    ? Icons.favorite
                                    : Icons.format_list_numbered_rtl,
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(item['subtitle'], maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.redAccent),
                          onPressed: () => _removeFavorite(item['id']),
                        ),
                      ),
                    ).animate().fadeIn(duration: 300.ms);
                  },
                ).animate().fadeIn(duration: 300.ms),
    );
  }
}
