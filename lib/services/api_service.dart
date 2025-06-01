import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../data/user_data.dart';
import 'user_storage.dart';
import '../data/docking_spot_data.dart';
import '../data/guides_data.dart';
import '../data/bookings_data.dart';
import '../data/notifications_data.dart';
import '../data/comments_data.dart';
import '../data/reviews_data.dart';
 
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
    } catch (error) {
      print('Get user error: $error');
      return false;
    }
  }

  Future<List<DockingSpotData>> getDockingSpots() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/docking-spots/list');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> dockingspots = response.data!['docking_spots'];
        return dockingspots
            .map((spot) => DockingSpotData.fromJson(spot as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Get docking spots error: $e');
      return [];
    }
  }

  Future<List<GuidesData>> getGuides() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/guides/list');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> guides = response.data!['guides'];
        return guides
            .map((guide) => GuidesData.fromJson(guide as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Get docking spots error: $e');
      return [];
    }
  }

  Future<List<BookingsData>> getBookigs() async {
    try {
      final currentUser = await UserStorage.currentUser;
      if (currentUser == null) return [];

      final response = await _dio.get<Map<String, dynamic>>('/bookings/list?sailor_id=${currentUser.id}');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> bookings = response.data!['bookings'];
        return bookings
            .map((guide) => BookingsData.fromJson(guide as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Get docking spots error: $e');
      return [];
    }
  }

  Future<void> submitBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await _dio.post(
        '/bookings',
        data: bookingData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to submit booking');
      }
    } catch (e) {
      print('Submit booking error: $e');
      rethrow;
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      await _dio.delete('/bookings/$bookingId');
    } catch (e) {
      print('Delete booking error: $e');
      rethrow;
    }
  }

  Future<DockingSpotData?> getDockById(String dockId) async {
    try {
      final response = await _dio.get('/docking-spots/$dockId');
      if (response.statusCode == 200 && response.data != null) {
        return DockingSpotData.fromJson(response.data);
      }
    } catch (e) {
      print("Failed to get dock: $e");
    }
    return null;
  }

  Future<List<NotificationData>> getNotifications() async {
    try {
      final currentUser = await UserStorage.currentUser;
      if (currentUser == null) return [];

      final response = await _dio.get<List<dynamic>>('/notifications/list?sailor_id=${currentUser.id}');
      if (response.statusCode == 200 && response.data != null) {
        return response.data!
            .map((n) => NotificationData.fromJson(n as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Get notifications error: $e');
      return [];
    }
  }

  // COMMENTS
  Future<List<CommentData>> getComments({int page = 1, int pageSize = 20}) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/comments/list',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      if (response.statusCode == 200 && response.data != null) {
        return response.data!
            .map((c) => CommentData.fromJson(c as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Get comments error: $e');
      return [];
    }
  }

  Future<CommentData?> getCommentById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/comments/$id');
      if (response.statusCode == 200 && response.data != null) {
        return CommentData.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      print('Get comment by id error: $e');
      return null;
    }
  }

  // REVIEWS
  Future<List<ReviewData>> getReviews() async {
    try {
      final response = await _dio.get<List<dynamic>>('/reviews/list');
      if (response.statusCode == 200 && response.data != null) {
        return response.data!
            .map((r) => ReviewData.fromJson(r as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Get reviews error: $e');
      return [];
    }
  }

  Future<ReviewData?> getReviewById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/reviews/$id');
      if (response.statusCode == 200 && response.data != null) {
        return ReviewData.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      print('Get review by id error: $e');
      return null;
    }
  }

  
  Future<bool> createReview(ReviewData review) async {
    /* 
    try {
      final response = await _dio.post(
        '/reviews',
        data: review.toJson(),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Create review error: $e');
      return false;
    }
    */
    return true;
  }
  
}

