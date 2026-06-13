import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:suitmedia_test/core/app_colors.dart';
import '../controllers/welcome_controller.dart';
import '../providers/app_state.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import 'main_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _palindromeController = TextEditingController();
  final WelcomeController _controller = WelcomeController();
  @override
  void dispose() {
    _nameController.dispose();
    _palindromeController.dispose();
    super.dispose();
  }

  void _checkPalindrome() {
    final String text = _palindromeController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a sentence to check.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    final bool isPal = _controller.isPalindrome(text);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Verification Result',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            isPal ? 'isPalindrome' : 'not palindrome',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _navigateToNext(AppState appState) {
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name first.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    appState.setName(name);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/first/background.png',
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 116,
                          height: 116,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/first/add_photo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 58),
                      AppTextField(
                        controller: _nameController,
                        hintText: 'Name',
                      ),
                      const SizedBox(height: 22),
                      AppTextField(
                        controller: _palindromeController,
                        hintText: 'Palindrome',
                      ),
                      const SizedBox(height: 45),
                      AppButton(label: 'CHECK', onPressed: _checkPalindrome),
                      const SizedBox(height: 15),
                      AppButton(
                        label: 'NEXT',
                        onPressed: () => _navigateToNext(appState),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
