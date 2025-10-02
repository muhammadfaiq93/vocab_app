import 'package:flutter/material.dart';
import '../constants/api_constants.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarPath;
  final String userName;
  final double size;
  final bool showBorder;
  final Color? backgroundColor;

  const UserAvatar({
    Key? key,
    this.avatarPath,
    required this.userName,
    this.size = 50,
    this.showBorder = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarPath != null && avatarPath!.isNotEmpty;
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        shape: BoxShape.circle,
        border: showBorder ? Border.all(color: Colors.white, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: hasAvatar
            ? Image.network(
                ApiConstants.getAvatarUrl(avatarPath),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildInitialFallback(initial);
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildInitialFallback(initial);
                },
              )
            : _buildInitialFallback(initial),
      ),
    );
  }

  Widget _buildInitialFallback(String initial) {
    return Container(
      color: backgroundColor ?? Color(0xFF6366F1).withOpacity(0.1),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            color: backgroundColor != null ? Colors.white : Color(0xFF6366F1),
          ),
        ),
      ),
    );
  }
}
