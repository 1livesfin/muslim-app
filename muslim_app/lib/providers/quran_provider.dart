import 'package:flutter/material.dart';

import '../services/quran_service.dart';

class QuranProvider extends ChangeNotifier {

  final QuranService service =
      QuranService();

  List surah = [];

  Future fetchSurah() async {

    final result =
        await service.getSurah();

    surah = result['data'];

    notifyListeners();
  }
}