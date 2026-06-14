import 'api_service.dart';

class QuranService {

  final ApiService api = ApiService();

  Future getSurah() async {

    return await api.get(
      "https://equran.id/api/v2/surat",
    );
  }

  Future getDetailSurah(int nomor) async {

    return await api.get(
      "https://equran.id/api/v2/surat/$nomor",
    );
  }
}