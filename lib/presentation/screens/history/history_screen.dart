import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/meal.dart';
import '../../widgets/meal_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _api = ApiClient();
  List<Meal> _meals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() => _loading = true);
    try {
      final response = await _api.get('/meals', queryParams: {'per_page': '50'});
      final list = response['meals'] as List<dynamic>;
      setState(() {
        _meals =
            list.map((m) => Meal.fromJson(m as Map<String, dynamic>)).toList();
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
        title: const Text('Lịch sử'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _meals.isEmpty
              ? const Center(
                  child: Text(
                    'Chưa có lịch sử ăn uống',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadMeals,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _meals.length,
                    itemBuilder: (context, index) {
                      return MealCard(meal: _meals[index], onTap: () {});
                    },
                  ),
                ),
    );
  }
}