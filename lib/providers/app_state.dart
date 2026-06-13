import 'package:flutter/foundation.dart';

class AppState with ChangeNotifier {
  String _name = '';
  String _selectedUserName = 'Selected User Name';
  String get name => _name;
  String get selectedUserName => _selectedUserName;
  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setSelectedUserName(String userName) {
    _selectedUserName = userName;
    notifyListeners();
  }
}
