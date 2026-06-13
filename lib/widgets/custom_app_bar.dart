import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backArrowColor;
  const CustomAppBar({super.key, required this.title, this.backArrowColor});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/second/left_back_arrow.svg',
          width: 10,
          height: 18,
          colorFilter: backArrowColor != null
              ? ColorFilter.mode(backArrowColor!, BlendMode.srcIn)
              : null,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(color: AppColors.divider, height: 0.5),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0.5);
}
