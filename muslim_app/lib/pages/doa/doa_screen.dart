import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/doa_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/glass_card.dart';
import 'doa_detail_screen.dart';

class DoaScreen extends StatefulWidget {
  const DoaScreen({super.key});

  @override
  State<DoaScreen> createState() => _DoaScreenState();
}

class _DoaScreenState extends State<DoaScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<DoaProvider>();
      if (provider.doa.isEmpty) {
        await provider.fetchDoa();
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
        title: const Text('Doa Harian'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Consumer<DoaProvider>(
              builder: (context, provider, child) {
                if (provider.doa.isEmpty) {
                  return const Center(child: Text("Gagal memuat doa"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: provider.doa.length,
                  itemBuilder: (context, index) {
                    final item = provider.doa[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoaDetailScreen(doaItem: item),
                            ),
                          );
                        },
                        child: GlassCard(
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: AppColors.card,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              item['doa'] ?? '',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 16),
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
