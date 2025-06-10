import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/guides_data.dart';

class GuidesStorage {
  static const _key = 'current_docking_spot';

  static Future<void> save(GuidesData spot) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(spot.toJson());
    await prefs.setString(_key, jsonString);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<GuidesData?> get currentSpot async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return GuidesData.fromJson(data);
  }
}