import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/suggestion.dart';
import '../../../domain/enums/meal_type.dart';
import '../../../domain/enums/cuisine_origin.dart';
import '../../../domain/enums/event_type.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final _api = ApiClient();
  List<Suggestion> _suggestions = [];
  bool _loading = false;

  MealType? _filterMealType;
  CuisineOrigin? _filterOrigin;
  EventType? _filterEvent;
  String? _filterPrice;

  final _priceOptions = [
    null, '<50k', '50k', '50-100k', '100-200k', '200-500k', '>500k',
  ];

  Future<void> _generateSuggestions() async {
    setState(() => _loading = true);
    try {
      final body = <String, dynamic>{};
      if (_filterMealType != null) body['meal_type_id'] = _filterMealType!.index + 1;
      if (_filterOrigin != null) body['cuisine_origin_id'] = _filterOrigin!.index + 1;
      if (_filterEvent != null) body['event_type_id'] = _filterEvent!.index + 1;
      if (_filterPrice != null) body['price_range'] = _filterPrice;

      final response = await _api.post('/suggestions/generate', body: body);
      final list = response['suggestions'] as List<dynamic>;
      setState(() {
        _suggestions = list
            .map((s) => Suggestion.fromJson(s as Map<String, dynamic>))
            .toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.suggestions),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bộ lọc:', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterDropdown(
                        label: 'Loại món',
                        items: MealType.values.map((e) => e.displayName).toList(),
                        onChanged: (v) {
                          setState(() {
                            _filterMealType = v != null
                                ? MealType.values.firstWhere((e) => e.displayName == v)
                                : null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterDropdown(
                        label: 'Nguồn gốc',
                        items: CuisineOrigin.values.map((e) => e.displayName).toList(),
                        onChanged: (v) {
                          setState(() {
                            _filterOrigin = v != null
                                ? CuisineOrigin.values.firstWhere((e) => e.displayName == v)
                                : null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterDropdown(
                        label: 'Sự kiện',
                        items: EventType.values.map((e) => e.displayName).toList(),
                        onChanged: (v) {
                          setState(() {
                            _filterEvent = v != null
                                ? EventType.values.firstWhere((e) => e.displayName == v)
                                : null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Generate button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _generateSuggestions,
                icon: _loading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.lightbulb),
                label: Text(_loading ? 'Đang gợi ý...' : 'Gợi ý cho tôi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Suggestions list
          Expanded(
            child: _suggestions.isEmpty
                ? const Center(
                    child: Text(
                      'Nhấn "Gợi ý cho tôi" để bắt đầu',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          title: Text(
                            suggestion.meal.name ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (suggestion.meal.mealTypeName != null)
                                Text(
                                  'Loại: ${suggestion.meal.mealTypeName}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                suggestion.reason,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text(label),
      items: [
        DropdownMenuItem(value: null, child: const Text('Tất cả')),
        ...items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            )),
      ],
      onChanged: onChanged,
    );
  }
}