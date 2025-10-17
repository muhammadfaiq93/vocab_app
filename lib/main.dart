import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'services/api_service.dart';
import 'services/storage_service.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';
import 'providers/settings_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/progress_dashboard.dart';
import 'utils/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase Core FIRST
    await Firebase.initializeApp();

    // Then initialize Firebase Service
    await FirebaseService().initialize();
    final FCMToken = FirebaseService().fcmToken;
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
  }

  // Initialize storage
  await StorageService().initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              apiService: ApiService(),
              storageService: StorageService(),
            )..add(AuthCheckStatus()),
          ),
        ],
        child: Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
            return MaterialApp(
              title: settingsProvider.settings?.appInfo.appName ??
                  'Vocabulary App',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                fontFamily: 'Roboto',
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF6366F1),
                  brightness: Brightness.light,
                ),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF6366F1),
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
              ),
              themeMode: settingsProvider.darkModeEnabled
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: AuthChecker(),
              routes: {
                AppRoutes.login: (context) => LoginScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}

class AuthChecker extends StatefulWidget {
  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _isInitialCheck = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        print('🔍 Auth State: ${state.runtimeType}');

        // After initial check, set flag to false
        if (_isInitialCheck && state is! AuthInitial) {
          setState(() {
            _isInitialCheck = false;
          });
        }
      },
      builder: (context, state) {
        // Show splash screen only during initial app load
        if (_isInitialCheck && (state is AuthInitial || state is AuthLoading)) {
          return SplashScreen();
        }

        // After initial load, handle states
        if (state is AuthAuthenticated) {
          print('✅ User authenticated - showing Dashboard');
          return ProgressDashboard();
        } else if (state is AuthUnauthenticated || state is AuthError) {
          print('✅ User unauthenticated - showing LoginScreen');
          return LoginScreen();
        } else if (state is AuthLoading) {
          // During login/register operations, stay on current screen
          // LoginScreen will show its own loading indicator
          return LoginScreen();
        } else {
          // Fallback
          return SplashScreen();
        }
      },
    );
  }
}
