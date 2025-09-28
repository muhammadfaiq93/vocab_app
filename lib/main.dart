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
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return ProgressHomeScreen();
            } else {
              return OnboardingScreen();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
