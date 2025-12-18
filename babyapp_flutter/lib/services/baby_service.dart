import 'api_service.dart';
import '../models/baby_model.dart';

class BabyService {
  static Future<List<Baby>> getBabies() async {
    final response = await ApiService.get('babies');
    final List<dynamic> data =
    response is List ? List<dynamic>.from(response as Iterable<dynamic>) : <dynamic>[];
    return data.map((json) => Baby.fromJson(json)).toList();
  }

  static Future<Baby> getBaby(int id) async {
    final response = await ApiService.get('babies/$id');
    return Baby.fromJson(response);
  }

  static Future<Baby> createBaby(Map<String, dynamic> data) async {
    final response = await ApiService.post('babies', data);
    return Baby.fromJson(response['baby']);
  }

  static Future<Baby> updateBaby(int id, Map<String, dynamic> data) async {
    final response = await ApiService.put('babies/$id', data);
    return Baby.fromJson(response['baby']);
  }

  static Future<void> deleteBaby(int id) async {
    await ApiService.delete('babies/$id');
  }
}