import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AsmaulHusna {
  final int id;
  final String arabic;
  final String latin;
  final String translationId;
  final String meaning;

  AsmaulHusna({
    required this.id,
    required this.arabic,
    required this.latin,
    required this.translationId,
    required this.meaning,
  });

  factory AsmaulHusna.fromJson(Map<String, dynamic> json) {
    return AsmaulHusna(
      id: json['urutan'] ?? json['id'] ?? 0,
      arabic: json['arab'] ?? '',
      latin: json['latin'] ?? '',
      translationId: json['arti'] ?? '',
      meaning: json['arti'] ?? '',
    );
  }
}

class AsmaulHusnaProvider with ChangeNotifier {
  List<AsmaulHusna> _asmaulHusnaList = [];
  bool _isLoading = false;
  String? _error;

  List<AsmaulHusna> get asmaulHusnaList => _asmaulHusnaList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAsmaulHusna() async {
    if (_asmaulHusnaList.isNotEmpty) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://islamic-api-zhirrr.vercel.app/api/asmaulhusna'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          final List list = data['data'];
          _asmaulHusnaList = list.map((e) => AsmaulHusna(
            id: int.tryParse(e['index'].toString()) ?? 0,
            arabic: e['arabic'] ?? '',
            latin: e['latin'] ?? '',
            translationId: e['translation_id'] ?? '',
            meaning: e['translation_id'] ?? '',
          )).toList();
        }
      } else {
        _error = 'Gagal memuat data';
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
