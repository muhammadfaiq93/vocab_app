// SIMPLEST FIX: Update utils/app_routes.dart to disable auth

import '../screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/learning_screen.dart';
import '../screens/progress_home_screen.dart';
import '../screens/exam_screen.dart';
// REMOVE THIS LINE TO DISABLE AUTH:
// import '../blocs/auth/auth_bloc.dart';
import '../blocs/learning/learning_bloc.dart';
import '../blocs/exam/exam_bloc.dart';
import '../services/api_service.dart';
import '../screens/dashboard_screen.dart';
import '../screens/progress_dashboard.dart';

class AppRoutes {
  // static const String welcome = '/';
  static const String splashScreen = '/splash';
  static const String login = '/login';
  // static const String home = '/home';
  // static const String homeProgress = '/homeprogress';
  // static const String dashboard = '/dashboard';
  static const String progressDashboard = '/progressdashboard';
  // static const String learning = '/learning';
  // static const String exam = '/exam';
  // static const String profile = '/profile';
  // static const String settings = '/settings';

  static Route<dynamic> generateRoute(
      RouteSettings settings, ApiService apiService, String? token) {
    switch (settings.name) {
      // case welcome:
      //   return MaterialPageRoute(
      //     builder: (_) => WelcomeScreen(),
      //   );

      case login:
        // SIMPLIFIED: No BLoC, just direct navigation
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );

      // case home:
      //   return MaterialPageRoute(
      //     builder: (_) => HomeScreen(),
      //   );
      // case homeProgress:
      //   return MaterialPageRoute(
      //     builder: (_) => ProgressHomeScreen(),
      //   );
      case splashScreen:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      // case dashboard:
      //   return MaterialPageRoute(
      //     builder: (_) => DashboardScreen(),
      //   );
      case progressDashboard:
        return MaterialPageRoute(
          builder: (_) => ProgressDashboard(),
        );
      // case learning:
      //   return MaterialPageRoute(
      //     builder: (_) => MultiBlocProvider(
      //       providers: [
      //         BlocProvider(
      //           create: (context) => LearningBloc(
      //             apiService: apiService,
      //             token: token ?? 'demo_token',
      //           ),
      //         ),
      //       ],
      //       child: LearningScreen(),
      //     ),
      //   );

      // case exam:
      //   return MaterialPageRoute(
      //     builder: (_) => MultiBlocProvider(
      //       providers: [
      //         BlocProvider(
      //           create: (context) => ExamBloc(
      //             apiService: apiService,
      //             token: token ?? 'demo_token',
      //           ),
      //         ),
      //       ],
      //       child: const ExamScreen(),
      //     ),
      //   );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text(
                'Page not found',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        );
    }
  }

  // Temporary - always authenticated for testing
  static bool get isAuthenticated => true;
  static String? get currentToken => 'demo_token';
}
