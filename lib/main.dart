import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
                AppRoutes.splashScreen: (context) => SplashScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Optional: Add debug prints
        print('🔍 Auth State: ${state.runtimeType}');
      },
      builder: (context, state) {
        if (state is AuthInitial) {
          // App just started, checking auth status
          return SplashScreen();
        } else if (state is AuthLoading) {
          // Loading state (login/register/logout in progress)
          return SplashScreen();
        } else if (state is AuthAuthenticated) {
          // User is logged in
          print('✅ User authenticated - showing Dashboard');
          return ProgressDashboard();
        } else if (state is AuthUnauthenticated) {
          // User is logged out or not logged in
          print('✅ User unauthenticated - showing LoginScreen');
          return LoginScreen();
        } else if (state is AuthError) {
          // Error state - show login with error
          return LoginScreen();
        } else {
          // Fallback - show login
          return SplashScreen();
        }
      },
    );
  }
}
