import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../widgets/glass_card.dart';

class PrayerDetailScreen extends StatelessWidget {
  final Map jadwal;
  final String lokasi;

  const PrayerDetailScreen({super.key, required this.jadwal, required this.lokasi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Jadwal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.mosque, size: 80, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(
              lokasi,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 5),
            Text(
              jadwal['tanggal'] ?? '',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 30),
            GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    _buildTimeRow('Imsak', jadwal['imsak'] ?? '-'),
                    const Divider(color: Colors.black12),
                    _buildTimeRow('Subuh', jadwal['subuh'] ?? '-'),
                    const Divider(color: Colors.black12),
                    _buildTimeRow('Terbit', jadwal['terbit'] ?? '-'),
                    const Divider(color: Colors.black12),
                    _buildTimeRow('Dhuha', jadwal['dhuha'] ?? '-'),
                    const Divider(color: Colors.black12),
                    _buildTimeRow('Dzuhur', jadwal['dzuhur'] ?? '-'),
                    const Divider(color: Colors.black12),
                    _buildTimeRow('Ashar', jadwal['ashar'] ?? '-'),
                    const Divider(color: Colors.black12),
                    _buildTimeRow('Maghrib', jadwal['maghrib'] ?? '-'),
                    const Divider(color: Colors.black12),
                    _buildTimeRow('Isya', jadwal['isya'] ?? '-'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 18, color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
