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
          print("USER JSON: ");
          print(userJson);
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
      final response = await _dio.get<Map<String, dynamic>>('/docking-spots/list?limit=10000');

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

  Future<List<DockingSpotData>> getOwnerDockingSpots() async {
    try {
      final currentUser = await UserStorage.currentUser;
      if (currentUser == null) return [];

      final response = await _dio.get<Map<String, dynamic>>('/docking-spots/list?owner_id=${currentUser.id}');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> spots = response.data!['docking_spots'];
        return spots
            .map((guide) => DockingSpotData.fromJson(guide as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Get docking spots error: $e');
      return [];
    }
  }

  Future<void> submitDockingSpot(Map<String, dynamic> dockingSpotData) async {
    try {
      final response = await _dio.post(
        '/docking-spots',
        data: dockingSpotData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to submit docking spot');
      }
    } catch (e) {
      print('Submit docking spot error: $e');
      rethrow;
    }
  }

  Future<void> updateDockingSpot(String dockId, Map<String, dynamic> updatedData) async {
    try {
      final response = await _dio.put('/docking-spots/$dockId', data: updatedData);

      if (response.statusCode == 200) {
        print("Dock updated successfully.");
      } else {
        throw Exception("Failed to update dock: ${response.statusCode}");
      }
    } catch (e) {
      print("Update dock error: $e");
      rethrow;
    }
  }

  Future<void> deleteDock(String dockId) async {
    try {
      await _dio.delete('/docking-spots/$dockId');
    } catch (e) {
      print('Delete dock error: $e');
      rethrow;
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

  Future<UserProfile?> getUserById(String userId) async {
    try {
      final response = await _dio.get('/users/$userId');

      if (response.statusCode == 200 && response.data != null) {
        final userJson = response.data['user'];
        return UserProfile.fromJson(userJson);
      }
    } catch (e) {
      print("Failed to get dock: $e");
    }
    return null;
  }


  Future<List<BookingsData>> getBookings() async {
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

  Future<List<BookingsData>> getMyDockBookings() async {
    try {
      final currentUser = await UserStorage.currentUser;
      if (currentUser == null) return [];

      final response = await _dio.get<Map<String, dynamic>>('/bookings/list?dock_owner_id=${currentUser.id}');

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

      final response = await _dio.get<Map<String, dynamic>>('/notifications/list?user_id=${currentUser.id}');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> notifications = response.data!['notifications'];
        return notifications
            .map((guide) => NotificationData.fromJson(guide as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Get docking spots error: $e');
      return [];
    }
  }

  Future<void> createNotification(Map<String, dynamic> notificationData) async {
    try {
      final response = await _dio.post(
        '/notifications',
        data: notificationData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create notification');
      }
    } catch (e) {
      print('Create notification error: $e');
      rethrow;
    }
  }

  // REVIEWS
  Future<List<ReviewData>> getReviews(String dockId) async {
    try {
      final response = await _dio.get('/reviews/list?dock_id=${dockId}');
      if (response.statusCode == 200) {
        
        // If it's already a List, use it directly
        if (response.data is List) {
          final List<dynamic> reviewsJson = response.data;
          return reviewsJson.map((json) => ReviewData.fromJson(json)).toList();
        }
        
        // If it's a Map, look for common array keys
        if (response.data is Map) {
          final Map<String, dynamic> responseMap = response.data;
          
          // Try common keys in order of likelihood
          final possibleKeys = ['data', 'reviews', 'items', 'results'];
          for (String key in possibleKeys) {
            if (responseMap.containsKey(key) && responseMap[key] is List) {
              final List<dynamic> reviewsJson = responseMap[key];
              return reviewsJson.map((json) => ReviewData.fromJson(json)).toList();
            }
          }
        }
      }
      return [];
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
    try {
      // Convert the review to JSON, excluding the review_id if it's empty
      final reviewJson = review.toJson();
      if (reviewJson['review_id'] == '') {
        reviewJson.remove('review_id');
      }
      
      print('Sending review data: ${jsonEncode(reviewJson)}');
      
      final response = await _dio.post(
        '/reviews',
        data: reviewJson,
      );
      
      if (response.statusCode == 201) {
        print('Review created successfully');
        return true;
      } else {
        print('Create review error: Status ${response.statusCode}');
        print('Response: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Create review error: $e');
      if (e is DioException) {
        print('DioException details: ${e.response?.data}');
      }
      return false;
    }
  }
  
}

