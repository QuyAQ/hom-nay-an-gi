import 'package:flutter/material.dart';
import 'core/constants/colors.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/add_meal/add_meal_screen.dart';
import 'presentation/screens/history/history_screen.dart';
import 'presentation/screens/voice_input/voice_input_screen.dart';
import 'presentation/screens/suggestions/suggestion_screen.dart';

class HomNayAnGiApp extends StatelessWidget {
  const HomNayAnGiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hôm nay ăn gì?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add-meal': (context) => const AddMealScreen(),
        '/history': (context) => const HistoryScreen(),
        '/voice-input': (context) => const VoiceInputScreen(),
        '/suggestions': (context) => const SuggestionScreen(),
      },
    );
  }
}