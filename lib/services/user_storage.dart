import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../user_data.dart';

class UserStorage {
  static const _key = 'current_user';

  static Future<void> save(UserProfile user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode({
      'name': user.name,
      'surname': user.surname,
      'email': user.email,
      'role': user.role,
      'id': user.id,
      'phone': user.phone,
    });
    await prefs.setString(_key, jsonString);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<UserProfile?> get currentUser async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return UserProfile.fromJson(data);
  }
}

