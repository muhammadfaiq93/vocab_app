import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_state.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/progress_home_screen.dart';
import 'screens/learning_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'Children Vocabulary App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'System',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print('Current AuthState: ${state.runtimeType}'); // Debug log

        if (state is AuthAuthenticated) {
          print('Navigating to ProgressHomeScreen'); // Debug log
          return ProgressHomeScreen();
        } else if (state is AuthLoading) {
          print('Showing loading screen'); // Debug log
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          print('Showing OnboardingScreen'); // Debug log
          return OnboardingScreen();
        }
      },
    );
  }
}
