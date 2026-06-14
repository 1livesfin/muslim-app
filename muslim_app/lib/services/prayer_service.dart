import 'api_service.dart';

class PrayerService {

  final ApiService api = ApiService();

  Future getPrayer() async {

    return await api.get(
      "https://api.myquran.com/v2/sholat/jadwal/1206/2025/1",
    );
  }
}