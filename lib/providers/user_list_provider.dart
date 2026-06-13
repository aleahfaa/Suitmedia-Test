import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserListProvider with ChangeNotifier {
  static const String _apiKey =
      'pro_ddd76eb59979b84aff9fd8745d28048290d4f98fb0e62cf3d0688336e429bcb1';
  final List<User> _users = [];
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _hasError = false;
  String _errorMessage = '';
  String? _paginateErrorMessage;
  int _currentPage = 1;
  bool _hasMore = true;
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get hasMore => _hasMore;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  String? get paginateErrorMessage => _paginateErrorMessage;

  void clearPaginateError() {
    _paginateErrorMessage = null;
  }
  Future<void> fetchUsers({bool refresh = false}) async {
    if (_isLoading || _isRefreshing) return;
    if (refresh) {
      _isRefreshing = true;
      _currentPage = 1;
      _hasMore = true;
      _hasError = false;
      _users.clear();
      notifyListeners();
    } else {
      if (!_hasMore) return;
      _isLoading = true;
      _hasError = false;
      notifyListeners();
    }
    try {
      final url = Uri.parse(
        'https://reqres.in/api/users?page=$_currentPage&per_page=10',
      );
      final response = await http
          .get(url, headers: {'x-api-key': _apiKey})
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> userListJson = data['data'] as List<dynamic>;
        final int totalPages = data['total_pages'] as int;
        final List<User> newUsers = userListJson
            .map((item) => User.fromJson(item as Map<String, dynamic>))
            .toList();
        _users.addAll(newUsers);
        if (_currentPage >= totalPages || newUsers.isEmpty) {
          _hasMore = false;
        } else {
          _currentPage++;
        }
      } else {
        _hasError = _users.isEmpty;
        _errorMessage =
            'Server error (${response.statusCode}). Please try again.';
        if (kDebugMode) print('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      if (_users.isEmpty) {
        _hasError = true;
        _errorMessage = _friendlyError(e);
      } else {
        _paginateErrorMessage = _friendlyError(e);
      }
      if (kDebugMode) print('Error fetching users: $e');
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('SocketException') || msg.contains('Failed host lookup')) {
      return 'No internet connection.\nPlease check your network and try again.';
    }
    if (msg.contains('TimeoutException')) {
      return 'Request timed out.\nPlease try again.';
    }
    return 'Something went wrong.\nPlease try again.';
  }
}
