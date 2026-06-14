import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bantuan & Dukungan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExpansionTile(
            title: const Text('Bagaimana cara mencari arah kiblat?'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Buka halaman Arah Kiblat dari beranda. Pastikan GPS/Lokasi perangkat Anda aktif dan kalibrasi kompas dengan memutar perangkat membentuk angka 8.'),
              )
            ],
          ),
          ExpansionTile(
            title: const Text('Bagaimana cara mengganti akun?'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Masuk ke halaman Profil, tekan tombol Keluar (Logout) di bagian bawah, lalu login kembali dengan akun yang baru.'),
              )
            ],
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text('Butuh bantuan lebih lanjut? Hubungi kami di support@muslimmate.com', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          )
        ],
      ),
    );
  }
}
