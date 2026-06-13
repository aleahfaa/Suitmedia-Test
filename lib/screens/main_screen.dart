import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../providers/app_state.dart';
import '../widgets/app_button.dart';
import '../widgets/custom_app_bar.dart';
import 'user_list_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Second Screen',
        backArrowColor: AppColors.accentPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Consumer<AppState>(
                    builder: (context, state, child) {
                      return Text(
                        state.name.isEmpty ? 'John Doe' : state.name,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Consumer<AppState>(
                    builder: (context, state, child) {
                      return Text(
                        state.selectedUserName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      );
                    },
                  ),
                ),
              ),
              AppButton(
                label: 'Choose a User',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserListScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
