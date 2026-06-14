import 'package:flutter/material.dart';

import '../../services/quran_service.dart';
import '../../theme/colors.dart';
import '../../widgets/glass_card.dart';

class QuranDetailScreen extends StatefulWidget {
  final int nomor;
  final String namaLatin;

  const QuranDetailScreen({
    super.key,
    required this.nomor,
    required this.namaLatin,
  });

  @override
  State<QuranDetailScreen> createState() => _QuranDetailScreenState();
}

class _QuranDetailScreenState extends State<QuranDetailScreen> {
  final QuranService _service = QuranService();
  Map? detailSurah;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final result = await _service.getDetailSurah(widget.nomor);
      setState(() {
        detailSurah = result['data'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.namaLatin),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : detailSurah == null
              ? const Center(child: Text("Gagal memuat surat"))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: (detailSurah!['ayat'] as List).length,
                  itemBuilder: (context, index) {
                    final ayat = detailSurah!['ayat'][index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: const BoxDecoration(
                                      color: AppColors.card,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${ayat['nomorAyat']}",
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      ayat['teksArab'] ?? '',
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.black87,
                                        height: 1.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Text(
                                ayat['teksLatin'] ?? '',
                                style: const TextStyle(
                                  color: AppColors.secondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Divider(color: Colors.black12),
                              const SizedBox(height: 10),
                              Text(
                                ayat['teksIndonesia'] ?? '',
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
