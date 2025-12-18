import 'api_service.dart';
import '../models/food_model.dart';

class FoodService {
  static Future<List<Food>> getFoods() async {
    final response = await ApiService.get('foods');
    final List<dynamic> data =
    response is List ? List<dynamic>.from(response as Iterable<dynamic>) : <dynamic>[];
    return data.map((json) => Food.fromJson(json)).toList();
  }

  static Future<List<Food>> getBabyFoods(int babyId) async {
    final response = await ApiService.get('babies/$babyId/foods');
    final List<dynamic> data =
    response is List ? List<dynamic>.from(response as Iterable<dynamic>) : <dynamic>[];
    return data.map((json) => Food.fromJson(json)).toList();
  }

  static Future<void> addBabyFood(int babyId, Map<String, dynamic> data) async {
    await ApiService.post('babies/$babyId/foods', data);
  }
}