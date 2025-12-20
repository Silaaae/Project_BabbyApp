import 'api_service.dart';
import '../models/growth_model.dart';

class GrowthService {
  static Future<List<Growth>> getGrowths(int babyId) async {
    final response = await ApiService.get('babies/$babyId/growths');

    final List<dynamic> data =
    response is List ? List<dynamic>.from(response as Iterable) : <dynamic>[];
    return data.map((json) => Growth.fromJson(json)).toList();
  }


  static Future<Growth> addGrowth(int babyId, Map<String, dynamic> data) async {
    final response = await ApiService.post('babies/$babyId/growths', data);
    return Growth.fromJson(response['growth']);
  }

  static Future<Map<String, dynamic>> getGrowthChart(int babyId) async {
    return await ApiService.get('babies/$babyId/growth-chart');
  }
}