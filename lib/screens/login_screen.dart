import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/custom_text_field.dart';
import '../utils/validators.dart';
import '../utils/app_routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isRegister = false;
  bool _obscurePassword = true;
  bool _isRegistering = false; // Track if we're in registration flow

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          // If error during registration, don't show success dialog
          if (_isRegistering) {
            _isRegistering = false;
            // Check if it's an account activation error
            if (state.message.toLowerCase().contains('pending') ||
                state.message.toLowerCase().contains('activation') ||
                state.message.toLowerCase().contains('check your email')) {
              _showAccountPendingDialog(context);
            } else if (!state.message.toLowerCase().contains('exists')) {
              // Don't show error if user already exists, show success dialog instead
              _showErrorSnackBar(state.message);
            }
          } else {
            // Login error - check if account needs activation
            if (state.message.toLowerCase().contains('pending') ||
                state.message.toLowerCase().contains('activation') ||
                state.message.toLowerCase().contains('check your email')) {
              _showAccountPendingDialog(context);
            } else {
              _showErrorSnackBar(state.message);
            }
          }
        } else if (state is AuthAuthenticated) {
          // Only navigate if user is actually authenticated (login success)
          Navigator.pushReplacementNamed(context, AppRoutes.progressDashboard);
        } else if (state is AuthUnauthenticated && _isRegistering) {
          // Registration completed successfully - show email dialog
          _isRegistering = false;
          _showRegistrationSuccessDialog(context);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryBlue,
                AppColors.secondaryBlue,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildMainContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          Expanded(
            child: Text(
              _isRegister ? AppStrings.createAccount : AppStrings.welcomeBack,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildGreeting(),
              SizedBox(height: 32),
              _buildForm(),
              SizedBox(height: 32),
              _buildSubmitButton(),
              SizedBox(height: 24),
              _buildSwitchAuthMode(),
              if (!_isRegister) _buildDemoButton(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isRegister ? AppStrings.getStarted : AppStrings.goodToSeeYou,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          _isRegister
              ? 'Create your account to begin your vocabulary journey'
              : 'Sign in to continue your learning journey',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        if (_isRegister) ...[
          CustomTextField(
            controller: _nameController,
            label: AppStrings.fullName,
            icon: Icons.person_outline,
            hint: 'Enter your full name',
          ),
          SizedBox(height: 20),
          CustomTextField(
            controller: _ageController,
            label: AppStrings.age,
            icon: Icons.cake_outlined,
            hint: 'How old are you?',
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
        ],
        CustomTextField(
          controller: _emailController,
          label: AppStrings.emailAddress,
          icon: Icons.email_outlined,
          hint: 'your.email@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 20),
        _buildPasswordField(),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.password,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Enter your password',
              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[400],
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Container(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    _isRegister ? AppStrings.signUp : AppStrings.signIn,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSwitchAuthMode() {
    return Center(
      child: TextButton(
        onPressed: () {
          setState(() {
            _isRegister = !_isRegister;
            _nameController.clear();
            _ageController.clear();
            _emailController.clear();
            _passwordController.clear();
          });
        },
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16),
            children: [
              TextSpan(
                text: _isRegister
                    ? 'Already have an account? '
                    : 'Don\'t have an account? ',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              TextSpan(
                text: _isRegister ? AppStrings.signIn : AppStrings.signUp,
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoButton() {
    return Column(
      children: [
        SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {
              _emailController.text = 'faiq@gmail.com';
              _passwordController.text = '123456';
            },
            child: Text(
              'Use demo credentials',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showRegistrationSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mark_email_read_outlined,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Check Your Email!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'We\'ve sent you an important email with next steps to activate your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _emailController.text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Color(0xFFD97706), size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Please check your spam folder if you don\'t see it',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _isRegister = false;
                        _nameController.clear();
                        _ageController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3B82F6),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Got it!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAccountPendingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.hourglass_empty,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Account Pending',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Your account is not yet activated. Please check your email and follow the instructions we sent you to activate your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Color(0xFF10B981), size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Check your email inbox',
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF374151)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Color(0xFF10B981), size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Follow the activation link',
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF374151)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Color(0xFF10B981), size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Complete the activation process',
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF374151)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3B82F6),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Understood',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitForm() {
    final validationError = _validateForm();
    if (validationError != null) {
      _showErrorSnackBar(validationError);
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_isRegister) {
      final name = _nameController.text.trim();
      final age = int.tryParse(_ageController.text) ?? 0;

      // Set flag to show success dialog after registration
      setState(() {
        _isRegistering = true;
      });

      context.read<AuthBloc>().add(
          AuthRegister(name: name, email: email, password: password, age: age));
      _isRegister = false;
    } else {
      context.read<AuthBloc>().add(AuthLogin(email: email, password: password));
    }
  }

  String? _validateForm() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (!Validators.isValidEmail(_emailController.text)) {
      return AppStrings.invalidEmail;
    }

    if (!Validators.isValidPassword(_passwordController.text)) {
      return AppStrings.passwordTooShort;
    }

    if (_isRegister) {
      if (_nameController.text.isEmpty || _ageController.text.isEmpty) {
        return AppStrings.fieldRequired;
      }

      final age = int.tryParse(_ageController.text) ?? 0;
      if (!Validators.isValidAge(age)) {
        return AppStrings.invalidAge;
      }
    }

    return null;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }
}
