import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/auth/auth_event.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLightMode = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return Center(child: CircularProgressIndicator());
        }

        final user = state.user;
        String fullName = user['name'] ?? 'Sm Jony';
        String email = user['email'] ?? 'jony@email.com';

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            _buildProfileSection(fullName, email),
                            SizedBox(height: 30),
                            _buildStatsCards(),
                            SizedBox(height: 30),
                            _buildAppSettings(),
                            SizedBox(height: 20),
                            _buildAccountSettings(),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Title section
          Text(
            'Your Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '"Your journey, your words, your way."',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Monday, June 24, 2025',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(String name, String email) {
    return Column(
      children: [
        // Profile Avatar
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF4ECDC4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF4ECDC4),
              ),
              child: Center(
                child: Text(
                  '👨‍💻',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),

        // Name
        Text(
          name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 8),

        // Email and Edit button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 20),
            Text(
              email,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                // Edit profile functionality
                _showEditProfileDialog();
              },
              child: Text(
                'Edit ✏️',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '150 Words',
            'Total Learned',
            Icons.menu_book,
            Color(0xFFE8F3FF),
            Color(0xFF6366F1),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            '5 Days',
            'Current Streak',
            Icons.local_fire_department,
            Color(0xFFFFF0E6),
            Color(0xFFFF8C42),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon,
      Color bgColor, Color iconColor) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 16),
          child: Row(
            children: [
              Icon(
                Icons.settings,
                color: Color(0xFF6B7280),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'App Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        _buildSettingItem(
          icon: Icons.wb_sunny,
          title: 'Light',
          trailing: Switch(
            value: isLightMode,
            onChanged: (value) {
              setState(() {
                isLightMode = value;
              });
            },
            activeColor: Color(0xFF6366F1),
          ),
          iconColor: Color(0xFFFBBF24),
        ),
        SizedBox(height: 4),
        _buildSettingItem(
          icon: Icons.text_fields,
          title: 'Font Size',
          hasArrow: true,
          onTap: () {
            _showFontSizeDialog();
          },
          iconColor: Color(0xFF6366F1),
        ),
        SizedBox(height: 4),
        _buildSettingItem(
          icon: Icons.language,
          title: 'Language',
          hasArrow: true,
          onTap: () {
            _showLanguageDialog();
          },
          iconColor: Color(0xFF10B981),
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 16),
          child: Row(
            children: [
              Icon(
                Icons.account_circle,
                color: Color(0xFF6B7280),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        _buildSettingItem(
          icon: Icons.lock,
          title: 'Change Password',
          hasArrow: true,
          onTap: () {
            _showChangePasswordDialog();
          },
          iconColor: Color(0xFF6366F1),
        ),
        SizedBox(height: 4),
        _buildSettingItem(
          icon: Icons.logout,
          title: 'Logout',
          hasArrow: false,
          onTap: () {
            _showLogoutDialog();
          },
          iconColor: Colors.red,
          titleColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    bool hasArrow = false,
    VoidCallback? onTap,
    Color iconColor = const Color(0xFF6366F1),
    Color titleColor = const Color(0xFF1F2937),
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
            ),
            if (trailing != null) trailing,
            if (hasArrow)
              Icon(
                Icons.chevron_right,
                color: Color(0xFF6B7280),
              ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Text('Profile editing feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Font Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Small'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('Medium'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('Large'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('English'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('Spanish'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('French'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthLogout());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
