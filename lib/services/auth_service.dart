import 'api_service.dart';
import 'storage_service.dart';
import '../models/user_model.dart';

class AuthService {
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone': phone,
    };

    final response = await ApiService.post('register', data);

    if (response['token'] != null) {
      await StorageService.saveToken(response['token']);
      await StorageService.saveUser(response['user']);
    }

    return response;
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = {
      'email': email,
      'password': password,
    };

    final response = await ApiService.post('login', data);

    if (response['token'] != null) {
      await StorageService.saveToken(response['token']);
      await StorageService.saveUser(response['user']);
    }

    return response;
  }

  static Future<void> logout() async {
    try {
      await ApiService.post('logout', {});
    } catch (e) {
      // Continue même si l'API échoue
    }
    await StorageService.clearAll();
  }

  static Future<User?> getCurrentUser() async {
    final userData = await StorageService.getUser();
    if (userData != null) {
      return User.fromJson(userData);
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final token = await StorageService.getToken();
    return token != null;
  }
}