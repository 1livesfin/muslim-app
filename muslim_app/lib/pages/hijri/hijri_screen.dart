import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../theme/colors.dart';
import '../../widgets/glass_card.dart';

class HijriScreen extends StatefulWidget {
  const HijriScreen({super.key});

  @override
  State<HijriScreen> createState() => _HijriScreenState();
}

class _HijriScreenState extends State<HijriScreen> {
  DateTime selectedDate = DateTime.now();
  late HijriCalendar selectedHijri;

  final List<Map<String, String>> hariBesar = [
    {'tanggal': '1 Muharram', 'event': 'Tahun Baru Hijriyah'},
    {'tanggal': '12 Rabiul Awal', 'event': 'Maulid Nabi Muhammad SAW'},
    {'tanggal': '27 Rajab', 'event': 'Isra\' Mi\'raj'},
    {'tanggal': '1 Ramadhan', 'event': 'Awal Puasa Ramadhan'},
    {'tanggal': '17 Ramadhan', 'event': 'Nuzulul Qur\'an'},
    {'tanggal': '1 Syawal', 'event': 'Hari Raya Idul Fitri'},
    {'tanggal': '10 Dzulhijjah', 'event': 'Hari Raya Idul Adha'},
  ];

  final List<Map<String, String>> puasaSunnah = [
    {'hari': 'Senin & Kamis', 'keterangan': 'Puasa mingguan yang dianjurkan'},
    {'hari': 'Ayyamul Bidh', 'keterangan': 'Puasa tanggal 13, 14, 15 setiap bulan Hijriyah'},
    {'hari': 'Asyura', 'keterangan': 'Puasa tanggal 10 Muharram'},
    {'hari': 'Arafah', 'keterangan': 'Puasa tanggal 9 Dzulhijjah'},
  ];

  @override
  void initState() {
    super.initState();
    selectedHijri = HijriCalendar.fromDate(selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedHijri = HijriCalendar.fromDate(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalender Hijriyah')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Converter Card
            GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Konversi Tanggal',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                              ),
                              child: Column(
                                children: [
                                  const Text('Masehi', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.swap_horiz, color: AppColors.primary, size: 30),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Column(
                              children: [
                                const Text('Hijriyah', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(
                                  '${selectedHijri.hDay} ${selectedHijri.longMonthName} ${selectedHijri.hYear}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 30),
            
            const Text('Hari Besar Islam', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                .animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: hariBesar.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.event, color: AppColors.primary),
                    ),
                    title: Text(hariBesar[index]['event']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(hariBesar[index]['tanggal']!),
                  ),
                ).animate().fadeIn(delay: (300 + (index * 50)).ms).slideX(begin: -0.1, end: 0);
              },
            ),

            const SizedBox(height: 20),
            
            const Text('Jadwal Puasa Sunnah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                .animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: puasaSunnah.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.brightness_2, color: AppColors.primary),
                    ),
                    title: Text(puasaSunnah[index]['hari']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(puasaSunnah[index]['keterangan']!),
                  ),
                ).animate().fadeIn(delay: (600 + (index * 50)).ms).slideX(begin: 0.1, end: 0);
              },
            ),
          ],
        ),
      ),
    );
  }
}
