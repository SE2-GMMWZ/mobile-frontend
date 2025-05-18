import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../user_data.dart';
import 'user_storage.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl:
            'https://backend-se2-hdhfduhtdxa4gseh.polandcentral-01.azurewebsites.net',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  late final Dio _dio;
  late final CookieJar _cookieJar;

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.statusCode == 200 || response.statusCode == 202;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await _dio.post(
        '/logout'
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  Future<bool> register(UserProfile user, String password) async {
    try {
      final payload = user.toJson();
      payload['password'] = password;

      final response = await _dio.post(
        '/signup',
        data: payload,
      );
      return response.statusCode == 200 || response.statusCode == 202;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<bool> updateUser(UserProfile user) async {
    try {
      final response = await _dio.put(
        '/users/${user.id}',
        data: user.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Update user error: $e');
      return false;
    }
  }

  Future<bool> getUser() async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>('/user-info');

      if (response.statusCode == 200 && response.data != null) {
        final userJson = response.data!['user'];
        if (userJson is Map<String, dynamic>) {
          final user = UserProfile.fromJson(userJson);
          await UserStorage.save(user);
          return true;
        }
      }
      return false;
    } catch (error, stackTrace) {
      print('Get user error: $error');
      return false;
    }
  }
}

