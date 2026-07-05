import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/network/api_client.dart';
import '../../../domain/enums/meal_type.dart';
import '../../../domain/enums/nutrition_type.dart';
import '../../../domain/enums/cuisine_origin.dart';
import '../../../domain/enums/event_type.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _api = ApiClient();

  MealType? _selectedMealType;
  NutritionType? _selectedNutrition;
  CuisineOrigin? _selectedOrigin;
  EventType? _selectedEvent;
  String? _selectedPrice;
  int? _dinerCount;
  int _rating = 0;
  bool _saving = false;

  final _priceOptions = [
    '<50k', '50k', '50-100k', '100-200k', '200-500k', '>500k',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _api.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      await _api.post('/meals', body: {
        'name': _nameController.text,
        'meal_type_id': _selectedMealType?.index,
        'nutrition_type_id': _selectedNutrition?.index,
        'cuisine_origin_id': _selectedOrigin?.index,
        'event_type_id': _selectedEvent?.index,
        'address': _addressController.text,
        'price_range': _selectedPrice,
        'diner_count': _dinerCount,
        'rating': _rating,
        'notes': _notesController.text,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm món ăn!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.addMeal),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tên món
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên món ăn *',
                  prefixIcon: Icon(Icons.restaurant),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Nhập tên món' : null,
              ),
              const SizedBox(height: 16),

              // Loại món
              const Text('Loại món', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildChipSelector(
                items: MealType.values,
                selected: _selectedMealType,
                onSelected: (v) => setState(() => _selectedMealType = v),
              ),
              const SizedBox(height: 16),

              // Dinh dưỡng
              const Text('Dinh dưỡng', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildChipSelector(
                items: NutritionType.values,
                selected: _selectedNutrition,
                onSelected: (v) => setState(() => _selectedNutrition = v),
              ),
              const SizedBox(height: 16),

              // Nguồn gốc
              const Text('Nguồn gốc', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildChipSelector(
                items: CuisineOrigin.values,
                selected: _selectedOrigin,
                onSelected: (v) => setState(() => _selectedOrigin = v),
              ),
              const SizedBox(height: 16),

              // Sự kiện
              const Text('Sự kiện', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildChipSelector(
                items: EventType.values,
                selected: _selectedEvent,
                onSelected: (v) => setState(() => _selectedEvent = v),
              ),
              const SizedBox(height: 16),

              // Giá tiền
              const Text('Giá tiền', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildChipSelector(
                items: _priceOptions,
                selected: _selectedPrice,
                onSelected: (v) => setState(() => _selectedPrice = v),
              ),
              const SizedBox(height: 16),

              // Địa chỉ
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Số người
              Row(
                children: [
                  const Text('Số người: '),
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '1',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => _dinerCount = int.tryParse(v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Rating
              const Text('Đánh giá', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Row(
                children: List.generate(5, (i) {
                  return IconButton(
                    icon: Icon(
                      i < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => _rating = i + 1),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Ghi chú
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Nút lưu
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(AppStrings.save, style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChipSelector<T>({
    required List<T> items,
    required dynamic selected,
    required Function(T) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: items.map((item) {
        final label = item is Enum ? (item as dynamic).displayName : item.toString();
        final isSelected = item == selected;
        return FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) => onSelected(item),
          selectedColor: AppColors.primary.withOpacity(0.2),
          checkmarkColor: AppColors.primary,
        );
      }).toList(),
    );
  }
}