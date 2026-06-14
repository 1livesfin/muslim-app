import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/quran_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/glass_card.dart';
import 'quran_detail_screen.dart';

class QuranListScreen extends StatefulWidget {
  const QuranListScreen({super.key});

  @override
  State<QuranListScreen> createState() => _QuranListScreenState();
}

class _QuranListScreenState extends State<QuranListScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<QuranProvider>();
      if (provider.surah.isEmpty) {
        await provider.fetchSurah();
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Al-Quran Digital"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Consumer<QuranProvider>(
              builder: (context, provider, child) {
                if (provider.surah.isEmpty) {
                  return const Center(child: Text("Gagal memuat Al-Quran"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: provider.surah.length,
                  itemBuilder: (context, i) {
                    final item = provider.surah[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuranDetailScreen(
                                nomor: item['nomor'],
                                namaLatin: item['namaLatin'] ?? '',
                              ),
                            ),
                          );
                        },
                        child: GlassCard(
                          child: ListTile(
                            leading: Container(
                              width: 45,
                              height: 45,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.card,
                              ),
                              child: Center(
                                child: Text(
                                  "${item['nomor']}",
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              item['namaLatin'] ?? '',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              "${item['arti']} • ${item['jumlahAyat']} Ayat",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            trailing: Text(
                              item['nama'] ?? '',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}