import 'package:flutter/material.dart';

import '../services/prayer_service.dart';

class PrayerProvider extends ChangeNotifier {

  final PrayerService service =
      PrayerService();

  bool isLoading = false;

  Map data = {};

  Future fetchPrayer() async {

    isLoading = true;
    notifyListeners();

    try {

      data = await service.getPrayer();

    } finally {

      isLoading = false;
      notifyListeners();
    }
  }
}