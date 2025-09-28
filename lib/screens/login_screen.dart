import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/custom_text_field.dart';
import '../utils/validators.dart';

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
        if (state is AuthAuthenticated) {
          print('Login successful');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
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
          SizedBox(width: 48), // Balance the back button
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
        // Registration specific fields
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

        // Email field
        CustomTextField(
          controller: _emailController,
          label: AppStrings.emailAddress,
          icon: Icons.email_outlined,
          hint: 'your.email@example.com',
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: 20),

        // Password field
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
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
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
            // Clear form when switching
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
              // Demo login for testing
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

  void _submitForm() {
    // Validate required fields
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
      // context.read<AuthBloc>().add(AuthRegister(name, email, password, age));
      context.read<AuthBloc>().add(
          AuthRegister(name: name, email: email, password: password, age: age));
    } else {
      // context.read<AuthBloc>().add(AuthLogin(email, password));
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
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
