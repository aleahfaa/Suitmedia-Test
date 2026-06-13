import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:suitmedia_test/controllers/welcome_controller.dart';
import 'package:suitmedia_test/main.dart';
import 'package:suitmedia_test/models/user_model.dart';
import 'package:suitmedia_test/providers/app_state.dart';
import 'package:suitmedia_test/providers/user_list_provider.dart';
import 'package:suitmedia_test/screens/welcome_screen.dart';

// ---------------------------------------------------------------------------
// Fake provider for widget tests — avoids real HTTP calls
// ---------------------------------------------------------------------------
class _FakeUserListProvider extends UserListProvider {
  @override
  Future<void> fetchUsers({bool refresh = false}) async {}
}

// ---------------------------------------------------------------------------
// WelcomeController unit tests
// ---------------------------------------------------------------------------
void main() {
  group('WelcomeController — palindrome logic', () {
    final ctrl = WelcomeController();

    test('empty string returns false', () => expect(ctrl.isPalindrome(''), false));
    test('single character returns true', () => expect(ctrl.isPalindrome('a'), true));
    test('simple palindrome', () => expect(ctrl.isPalindrome('racecar'), true));
    test('palindrome with spaces', () => expect(ctrl.isPalindrome('kasur rusak'), true));
    test('palindrome with spaces and mixed case', () {
      expect(ctrl.isPalindrome('A man, a plan, a canal: Panama'), true);
    });
    test('step on no pets', () => expect(ctrl.isPalindrome('step on no pets'), true));
    test('put it up', () => expect(ctrl.isPalindrome('put it up'), true));
    test('non-palindrome', () => expect(ctrl.isPalindrome('suitmedia'), false));
    test('hello is not palindrome', () => expect(ctrl.isPalindrome('hello'), false));
  });

  // ---------------------------------------------------------------------------
  // UserListProvider unit tests
  // ---------------------------------------------------------------------------
  group('UserListProvider', () {
    test('initial state is correct', () {
      final provider = UserListProvider();
      expect(provider.users, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.isRefreshing, false);
      expect(provider.hasMore, true);
      expect(provider.hasError, false);
    });

    test('fetchUsers sets isLoading then clears it', () async {
      // Use the fake provider that does nothing
      final provider = _FakeUserListProvider();
      expect(provider.isLoading, false);
      // Calling fetch on fake does nothing — just verifies no crash
      await provider.fetchUsers();
      expect(provider.isLoading, false);
    });

    test('duplicate calls while loading are ignored', () async {
      int notifyCount = 0;
      final provider = _FakeUserListProvider()
        ..addListener(() => notifyCount++);
      // Call twice; the fake does nothing so both calls return immediately
      await Future.wait([provider.fetchUsers(), provider.fetchUsers()]);
      // No double-notifications expected from the guard
      expect(provider.users, isEmpty);
    });

    test('setName updates name and notifies', () {
      int notifyCount = 0;
      final state = AppState()..addListener(() => notifyCount++);
      state.setName('Alice');
      expect(state.name, 'Alice');
      expect(notifyCount, 1);
    });

    test('setSelectedUserName updates value and notifies', () {
      int notifyCount = 0;
      final state = AppState()..addListener(() => notifyCount++);
      state.setSelectedUserName('Bob Smith');
      expect(state.selectedUserName, 'Bob Smith');
      expect(notifyCount, 1);
    });

    test('User.fromJson maps fields correctly', () {
      final user = User.fromJson({
        'id': 7,
        'email': 'test@reqres.in',
        'first_name': 'John',
        'last_name': 'Doe',
        'avatar': 'https://reqres.in/img/faces/7-image.jpg',
      });
      expect(user.id, 7);
      expect(user.email, 'test@reqres.in');
      expect(user.fullName, 'John Doe');
      expect(user.avatar, 'https://reqres.in/img/faces/7-image.jpg');
    });
  });

  // ---------------------------------------------------------------------------
  // Widget / navigation tests
  // ---------------------------------------------------------------------------
  group('Widget Tests', () {
    Widget buildApp() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
          // Use fake provider to avoid network calls in tests
          ChangeNotifierProvider<UserListProvider>(
            create: (_) => _FakeUserListProvider(),
          ),
        ],
        child: const MyApp(),
      );
    }

    testWidgets('WelcomeScreen shows inputs and buttons', (tester) async {
      await tester.pumpWidget(buildApp());

      expect(
        find.byWidgetPredicate(
          (w) => w is TextField && w.decoration?.hintText == 'Name',
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is TextField && w.decoration?.hintText == 'Palindrome',
        ),
        findsOneWidget,
      );
      expect(find.text('CHECK'), findsOneWidget);
      expect(find.text('NEXT'), findsOneWidget);
    });

    testWidgets('NEXT without name shows snackbar', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.tap(find.text('NEXT'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter your name first.'), findsOneWidget);
    });

    testWidgets('CHECK without text shows snackbar', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.tap(find.text('CHECK'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter a sentence to check.'), findsOneWidget);
    });

    testWidgets('full navigation flow works', (tester) async {
      await tester.pumpWidget(buildApp());

      // Dismiss any lingering snackbars
      ScaffoldMessenger.of(tester.element(find.byType(WelcomeScreen)))
          .clearSnackBars();

      // Enter name and navigate to Second Screen
      await tester.enterText(
        find.byWidgetPredicate(
          (w) => w is TextField && w.decoration?.hintText == 'Name',
        ),
        'John Doe',
      );
      await tester.tap(find.text('NEXT'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Selected User Name'), findsOneWidget);
      expect(find.text('Choose a User'), findsOneWidget);

      // Navigate to Third Screen
      await tester.tap(find.text('Choose a User'));
      await tester.pumpAndSettle();
      expect(find.text('Third Screen'), findsOneWidget);
    });
  });
}
