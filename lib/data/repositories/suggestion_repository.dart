import '../models/suggestion.dart';
import '../../core/network/api_client.dart';

class SuggestionRepository {
  final ApiClient _api;

  SuggestionRepository(this._api);

  Future<List<Suggestion>> getSuggestions({
    int? mealTypeId,
    int? cuisineOriginId,
    int? nutritionTypeId,
    int? eventTypeId,
    String? priceRange,
  }) async {
    final body = <String, dynamic>{};
    if (mealTypeId != null) body['meal_type_id'] = mealTypeId;
    if (cuisineOriginId != null) body['cuisine_origin_id'] = cuisineOriginId;
    if (nutritionTypeId != null) body['nutrition_type_id'] = nutritionTypeId;
    if (eventTypeId != null) body['event_type_id'] = eventTypeId;
    if (priceRange != null) body['price_range'] = priceRange;

    final response = await _api.post('/suggestions/generate', body: body);
    final list = response['suggestions'] as List<dynamic>;
    return list.map((s) => Suggestion.fromJson(s as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>> parseVoice(String text) async {
    final response = await _api.post('/voice/parse', body: {'text': text});
    return response;
  }
}