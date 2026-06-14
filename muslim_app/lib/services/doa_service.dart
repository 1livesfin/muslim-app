import 'api_service.dart';

class DoaService {

  final ApiService api = ApiService();

  Future getDoa() async {

    return await api.get(
      "https://doa-doa-api-ahmadramadhan.fly.dev/api",
    );
  }
}