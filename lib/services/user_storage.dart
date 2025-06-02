import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../data/user_data.dart';

class UserStorage {
  static const _key = 'current_user';

  static Future<void> save(UserProfile user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode({
      'name': user.name,
      'surname': user.surname,
      'email': user.email,
      'role': user.role,
      'user_id': user.id,
      'phone_number': user.phone,
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
    print(data);
    print(data.entries);
    print(data.values);
    return UserProfile.fromJson(data);
  }
}

