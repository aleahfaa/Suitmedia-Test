class WelcomeController {
  bool isPalindrome(String text) {
    if (text.isEmpty) return false;
    final String clean = text
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toLowerCase();
    if (clean.isEmpty) return false;
    return clean == clean.split('').reversed.join('');
  }
}
