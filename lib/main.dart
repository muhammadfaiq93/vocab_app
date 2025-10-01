import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_state.dart';
import 'services/api_service.dart';
import 'utils/app_routes.dart';
import 'screens/onboarding_screen.dart';
// import 'screens/progress_home_screen.dart';
import 'screens/progress_dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(apiService: _apiService),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          // Get token from auth state if authenticated
          final token = authState is AuthAuthenticated ? authState.token : null;

          return MaterialApp(
            title: 'Children Vocabulary App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'System',
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: AuthWrapper(),
            onGenerateRoute: (settings) => AppRoutes.generateRoute(
              settings,
              _apiService,
              token,
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print('Current AuthState: ${state.runtimeType}');

        if (state is AuthAuthenticated) {
          return ProgressDashboard();
        } else if (state is AuthLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return OnboardingScreen();
        }
      },
    );
  }
}
