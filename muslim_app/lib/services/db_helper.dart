import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbHelper extends ChangeNotifier {
  static final DbHelper instance = DbHelper._init();
  
  DbHelper._init();

  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  Future<int> insertFavorite(Map<String, dynamic> row) async {
    final prefs = await _prefs;
    List<String> favoritesStr = prefs.getStringList('favorites_list') ?? [];
    
    // Generate a simple unique ID
    int id = DateTime.now().millisecondsSinceEpoch;
    row['id'] = id;
    
    favoritesStr.add(json.encode(row));
    await prefs.setStringList('favorites_list', favoritesStr);
    notifyListeners();
    return id;
  }

  Future<List<Map<String, dynamic>>> queryAllFavorites() async {
    final prefs = await _prefs;
    List<String> favoritesStr = prefs.getStringList('favorites_list') ?? [];
    
    return favoritesStr.map((e) => json.decode(e) as Map<String, dynamic>).toList();
  }

  Future<int> deleteFavorite(int id) async {
    final prefs = await _prefs;
    List<String> favoritesStr = prefs.getStringList('favorites_list') ?? [];
    
    final initialLength = favoritesStr.length;
    favoritesStr.removeWhere((e) {
      final map = json.decode(e) as Map<String, dynamic>;
      return map['id'] == id;
    });
    
    await prefs.setStringList('favorites_list', favoritesStr);
    notifyListeners();
    return initialLength - favoritesStr.length; // return count of deleted
  }

  Future<bool> isFavorite(String type, int itemId) async {
    final prefs = await _prefs;
    List<String> favoritesStr = prefs.getStringList('favorites_list') ?? [];
    
    for (var e in favoritesStr) {
      final map = json.decode(e) as Map<String, dynamic>;
      if (map['type'] == type && map['itemId'] == itemId) {
        return true;
      }
    }
    return false;
  }
}
