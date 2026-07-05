import 'meal.dart';

class Suggestion {
  final Meal meal;
  final double score;
  final String reason;

  Suggestion({
    required this.meal,
    required this.score,
    required this.reason,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      meal: Meal.fromShortJson(json['meal'] as Map<String, dynamic>),
      score: (json['score'] as num).toDouble(),
      reason: json['reason'] as String? ?? '',
    );
  }
}