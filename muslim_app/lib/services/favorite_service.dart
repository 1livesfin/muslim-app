import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  Future<void> saveFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> data =
        prefs.getStringList("favorite") ?? [];

    if (!data.contains(id)) {
      data.add(id);
    }

    await prefs.setStringList(
      "favorite",
      data,
    );
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList("favorite") ?? [];
  }

  Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> data =
        prefs.getStringList("favorite") ?? [];

    data.remove(id);

    await prefs.setStringList(
      "favorite",
      data,
    );
  }
}