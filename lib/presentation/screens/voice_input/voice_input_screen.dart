import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/network/api_client.dart';

class VoiceInputScreen extends StatefulWidget {
  const VoiceInputScreen({super.key});

  @override
  State<VoiceInputScreen> createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen>
    with SingleTickerProviderStateMixin {
  final _api = ApiClient();
  bool _isListening = false;
  bool _isProcessing = false;
  String _recognizedText = '';
  Map<String, dynamic>? _parsedResult;

  void _startListening() {
    // TODO: Integrate speech_to_text plugin
    // For now, simulate with text input dialog
    _showTextInputDialog();
  }

  void _showTextInputDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nhập nội dung'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Ví dụ: Ăn lẩu Thái với 4 người, tầm 200k',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _processVoice(controller.text);
            },
            child: const Text('Xử lý'),
          ),
        ],
      ),
    );
  }

  Future<void> _processVoice(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _recognizedText = text;
      _isProcessing = true;
    });

    try {
      final result = await _api.post('/voice/parse', body: {'text': text});
      setState(() {
        _parsedResult = result['parsed'] as Map<String, dynamic>;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  Future<void> _saveParsedMeal() async {
    if (_parsedResult == null) return;

    try {
      await _api.post('/meals', body: _parsedResult);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu món ăn!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.voiceInput),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            // Microphone button
            GestureDetector(
              onTap: _isProcessing ? null : _startListening,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isListening ? 160 : 120,
                height: _isListening ? 160 : 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isListening
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.primary,
                  boxShadow: _isListening
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  size: 48,
                  color: _isListening ? AppColors.primary : Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _isProcessing ? AppStrings.processing : AppStrings.tapToRecord,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Recognized text
            if (_recognizedText.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Đã nhận diện:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(_recognizedText),
                    ],
                  ),
                ),
              ),

            // Parsed result
            if (_parsedResult != null)
              Card(
                color: AppColors.secondary.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Thông tin nhận diện:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildResultRow(
                          'Loại món', _parsedResult?['meal_type_name']),
                      _buildResultRow(
                          'Nguồn gốc', _parsedResult?['cuisine_origin_name']),
                      _buildResultRow('Giá', _parsedResult?['price_range']),
                      _buildResultRow(
                          'Số người', _parsedResult?['diner_count']?.toString()),
                    ],
                  ),
                ),
              ),

            if (_parsedResult != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveParsedMeal,
                    icon: const Icon(Icons.save),
                    label: const Text('Lưu món ăn'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String? value) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}