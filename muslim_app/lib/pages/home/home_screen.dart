import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../theme/colors.dart';
// Removed duplicate
import '../quran/quran_list_screen.dart';
import '../qibla/qibla_screen.dart';
import '../prayer/prayer_screen.dart';
import '../doa/doa_screen.dart';
import '../about/about_screen.dart';
import '../asmaulhusna/asmaulhusna_screen.dart';
import '../ai/ai_assistant_screen.dart';
import '../hijri/hijri_screen.dart';
import '../../providers/doa_provider.dart';
import '../../providers/prayer_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoaProvider>().fetchDoa();
      context.read<PrayerProvider>().fetchPrayer();
    });
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final List<String> days = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
    ];
    
    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];
    
    return '$dayName, ${now.day} $monthName ${now.year}';
  }

  String _getHijriDate() {
    var today = HijriCalendar.now();
    return '${today.hDay} ${today.longMonthName} ${today.hYear} H';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Ambient Background Glows
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(isDark ? 0.15 : 0.3),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: Container(),
              ),
            ),
          ).animate().fadeIn(duration: 1000.ms),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(isDark ? 0.1 : 0.2),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: Container(),
              ),
            ),
          ).animate().fadeIn(duration: 1000.ms, delay: 200.ms),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Assalamu'alaikum,",
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Hamba Allah",
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              child: const Icon(Icons.person, color: AppColors.primary),
                            ),
                          ],
                        ).animate().slideX(begin: -0.2, end: 0).fadeIn(duration: 600.ms),
                        const SizedBox(height: 30),

                        // Main Banner
                        _buildMainBanner().animate().slideY(begin: 0.2, end: 0).fadeIn(duration: 600.ms, delay: 200.ms),
                        const SizedBox(height: 30),

                        Text(
                          "Menu Utama",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.7,
                    children: [
                      _buildMenu(context, Icons.mosque, "Jadwal", const PrayerScreen(), 0),
                      _buildMenu(context, Icons.menu_book, "Al-Quran", const QuranListScreen(), 1),
                      _buildMenu(context, Icons.favorite, "Doa", const DoaScreen(), 2),
                      _buildMenu(context, Icons.format_list_numbered_rtl, "Asmaul\nHusna", const AsmaulHusnaScreen(), 3),
                      _buildMenu(context, Icons.explore, "Kiblat", const QiblaScreen(), 4),
                      _buildMenu(context, Icons.psychology, "AI\nAssistant", const AiAssistantScreen(), 5),
                      _buildMenu(context, Icons.calendar_month, "Hijriyah", const HijriScreen(), 6),
                      _buildMenu(context, Icons.info_outline, "Tentang", const AboutScreen(), 7),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainBanner() {
    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1564683214964-b31b92d78772?q=80&w=1000&auto=format&fit=crop'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      _getFormattedDate(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.nights_stay, color: Colors.white, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      _getHijriDate(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Waktu Maghrib",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 2),
                const Text(
                  "18:12 WIB",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 32),
                ),
                const SizedBox(height: 4),
                const Text(
                  "-02:15:30 menuju Maghrib", // Should be dynamic
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context, IconData icon, String title, Widget targetScreen, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => targetScreen));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
              ],
              border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
            ),
            child: Icon(icon, size: 30, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ).animate().scale(delay: (400 + (index * 50)).ms).fadeIn(),
    );
  }
}