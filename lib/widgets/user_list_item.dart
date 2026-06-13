import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../models/user_model.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback onTap;
  const UserListItem({super.key, required this.user, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${user.fullName}, ${user.email}',
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              ClipOval(
                child: Image.network(
                  user.avatar,
                  width: 49,
                  height: 49,
                  fit: BoxFit.cover,
                  semanticLabel: '${user.fullName} avatar',
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/third/profile_picture.jpg',
                    width: 49,
                    height: 49,
                    fit: BoxFit.cover,
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 49,
                      height: 49,
                      color: AppColors.shimmerBase,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMediumLight,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
