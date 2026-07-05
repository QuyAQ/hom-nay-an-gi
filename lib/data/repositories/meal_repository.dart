import '../models/meal.dart';
import '../../core/network/api_client.dart';

class MealRepository {
  final ApiClient _api;

  MealRepository(this._api);

  Future<List<Meal>> getMeals({Map<String, String>? filters}) async {
    final response = await _api.get('/meals', queryParams: filters);
    final mealsList = response['meals'] as List<dynamic>;
    return mealsList.map((m) => Meal.fromJson(m as Map<String, dynamic>)).toList();
  }

  Future<Meal> createMeal(Map<String, dynamic> data) async {
    final response = await _api.post('/meals', body: data);
    return Meal.fromJson(response);
  }

  Future<Meal> updateMeal(String id, Map<String, dynamic> data) async {
    final response = await _api.put('/meals/$id', body: data);
    return Meal.fromJson(response);
  }

  Future<void> deleteMeal(String id) async {
    await _api.delete('/meals/$id');
  }
}