import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const AppButton({super.key, required this.label, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.background,
          ),
        ),
      ),
    );
  }
}
