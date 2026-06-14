import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/prayer_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/glass_card.dart';
import 'prayer_detail_screen.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PrayerProvider>();
      if (provider.data.isEmpty) {
        provider.fetchPrayer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Shalat'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<PrayerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (provider.data.isEmpty || provider.data['data'] == null) {
            return const Center(child: Text("Data tidak tersedia"));
          }

          final lokasi = provider.data['data']['lokasi'] ?? '';
          final jadwal = provider.data['data']['jadwal'] as List? ?? [];

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primary, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        lokasi,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = jadwal[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrayerDetailScreen(jadwal: item, lokasi: lokasi),
                            ),
                          );
                        },
                        child: GlassCard(
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.card,
                              child: Icon(Icons.calendar_today, color: AppColors.primary),
                            ),
                            title: Text(
                              item['tanggal'] ?? '',
                              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Subuh: ${item['subuh']} | Maghrib: ${item['maghrib']}",
                              style: const TextStyle(color: Colors.black54),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 16),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: jadwal.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          );
        },
      ),
    );
  }
}
