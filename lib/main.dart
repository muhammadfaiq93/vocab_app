import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/api_service.dart';
import 'utils/app_routes.dart';
import 'constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(VocabularyApp());
}

class VocabularyApp extends StatelessWidget {
  // FIXED: Create ApiService instance
  final ApiService _apiService = ApiService();
  final String? _currentToken = AppRoutes.currentToken;

  VocabularyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocabulary Adventure',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppColors.primaryColor,
        fontFamily: 'Comic Sans MS',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
        ),
      ),
      initialRoute:
          AppRoutes.isAuthenticated ? AppRoutes.home : AppRoutes.welcome,
      // FIXED: Pass apiService and token to route generation
      onGenerateRoute: (settings) =>
          AppRoutes.generateRoute(settings, _apiService, _currentToken),
      debugShowCheckedModeBanner: false,
    );
  }
}
