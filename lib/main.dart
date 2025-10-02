// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/progress_dashboard.dart'; // Your dashboard
import 'utils/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  await StorageService().initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            apiService: ApiService(),
            storageService: StorageService(),
          )..add(AuthCheckStatus()), // Check auth status on start
        ),
        // Add other BLoCs here
      ],
      child: MaterialApp(
        title: 'Vocabulary App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
        ),
        home: AuthChecker(),
        routes: {
          AppRoutes.login: (context) => LoginScreen(),
          AppRoutes.progressDashboard: (context) => ProgressDashboard(
              //userName: StorageService().currentUser?.name ?? 'User',
              //childId: StorageService().userId ?? 0,
              ),
          // Add other routes
        },
      ),
    );
  }
}

// Auth checker widget
class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return SplashScreen();
        } else if (state is AuthAuthenticated) {
          return ProgressDashboard(
              //userName: state.user.name,
              //childId: state.user.id,
              );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
