class Meal {
  final String? id;
  final String name;
  final int? mealTypeId;
  final String? mealTypeName;
  final int? nutritionTypeId;
  final String? nutritionTypeName;
  final int? cuisineOriginId;
  final String? cuisineOriginName;
  final int? eventTypeId;
  final String? eventTypeName;
  final String? address;
  final String? googleMapsLink;
  final String? priceRange;
  final int? dinerCount;
  final int? rating;
  final String? notes;
  final String? mealDate;
  final String? createdAt;
  final String? updatedAt;

  Meal({
    this.id,
    required this.name,
    this.mealTypeId,
    this.mealTypeName,
    this.nutritionTypeId,
    this.nutritionTypeName,
    this.cuisineOriginId,
    this.cuisineOriginName,
    this.eventTypeId,
    this.eventTypeName,
    this.address,
    this.googleMapsLink,
    this.priceRange,
    this.dinerCount,
    this.rating,
    this.notes,
    this.mealDate,
    this.createdAt,
    this.updatedAt,
  });

factory Meal.fromShortJson(Map<String, dynamic> json) {
  return Meal(
    id: json['id'] as String?,
    name: json['name'] as String? ?? '',
    mealTypeName: json['meal_type'] as String?,
    cuisineOriginName: json['cuisine_origin'] as String?,
    priceRange: json['price_range'] as String?,
    rating: json['rating'] as int?,
    mealDate: json['meal_date'] as String?,
  );
}

  factory Meal.fromShortJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      mealTypeName: json['meal_type'] as String?,
      cuisineOriginName: json['cuisine_origin'] as String?,
      priceRange: json['price_range'] as String?,
      rating: json['rating'] as int?,
      meal: Meal.fromShortJson(json['meal']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'meal_type_id': mealTypeId,
      'nutrition_type_id': nutritionTypeId,
      'cuisine_origin_id': cuisineOriginId,
      'event_type_id': eventTypeId,
      'address': address,
      'google_maps_link': googleMapsLink,
      'price_range': priceRange,
      'diner_count': dinerCount,
      'rating': rating,
      'notes': notes,
      'meal_date': mealDate,
    };
  }
}