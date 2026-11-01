import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterdemo/models/user_profile.dart';
import 'package:flutterdemo/routes/app_routes.dart';
import 'package:flutterdemo/screens/common/profile_settings_screen.dart';

void main() {
  Future<void> useTallSurface(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  Widget buildProfile(UserProfile profile) {
    return MaterialApp(home: ProfileSettingsScreen(profile: profile));
  }

  group('Profile details', () {
    testWidgets('shows learner name, email, role badge and enrolled count',
        (tester) async {
      await useTallSurface(tester);
      await tester.pumpWidget(buildProfile(UserProfile.learnerDemo));

      expect(find.text('Student User'), findsOneWidget);
      expect(find.text('student@edtech.com'), findsOneWidget);
      expect(find.text('Learner'), findsOneWidget);
      expect(find.text('Teacher'), findsNothing);
      expect(find.text('Enrolled Courses'), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('course_count'))).data,
        '3',
      );
    });

    testWidgets('shows teacher role badge and published count',
        (tester) async {
      await useTallSurface(tester);
      await tester.pumpWidget(buildProfile(UserProfile.teacherDemo));

      expect(find.text('Instructor'), findsOneWidget);
      expect(find.text('teacher@edtech.com'), findsOneWidget);
      expect(find.text('Teacher'), findsOneWidget);
      expect(find.text('Learner'), findsNothing);
      expect(find.text('Published Courses'), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('course_count'))).data,
        '4',
      );
    });
  });

  group('Preferences', () {
    testWidgets('notification and dark mode switches toggle', (tester) async {
      await useTallSurface(tester);
      await tester.pumpWidget(buildProfile(UserProfile.learnerDemo));

      final notifications = find.byKey(const ValueKey('notifications_switch'));
      final darkMode = find.byKey(const ValueKey('dark_mode_switch'));

      expect(tester.widget<SwitchListTile>(notifications).value, isTrue);
      expect(tester.widget<SwitchListTile>(darkMode).value, isFalse);

      await tester.tap(notifications);
      await tester.pump();
      await tester.tap(darkMode);
      await tester.pump();

      expect(tester.widget<SwitchListTile>(notifications).value, isFalse);
      expect(tester.widget<SwitchListTile>(darkMode).value, isTrue);
    });
  });

  group('Logout', () {
    final navigatorKey = GlobalKey<NavigatorState>();

    // Home -> Profile, so there is an earlier screen the logout must clear.
    Widget buildApp() {
      return MaterialApp(
        navigatorKey: navigatorKey,
        routes: {
          '/': (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.profile,
                      arguments: UserProfile.learnerDemo,
                    ),
                    child: const Text('Open Profile'),
                  ),
                ),
              ),
          AppRoutes.profile: (context) => ProfileSettingsScreen(
                profile: ModalRoute.of(context)!.settings.arguments
                    as UserProfile,
              ),
          AppRoutes.roleSelection: (context) =>
              const Scaffold(body: Text('Role Selection Page')),
        },
      );
    }

    Future<void> openProfileAndTapLogout(WidgetTester tester) async {
      await useTallSurface(tester);
      await tester.pumpWidget(buildApp());
      await tester.tap(find.text('Open Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('logout_button')));
      await tester.pumpAndSettle();
    }

    testWidgets('Logout button asks for confirmation first', (tester) async {
      await openProfileAndTapLogout(tester);

      expect(find.text('Logout Confirmation'), findsOneWidget);
      expect(find.text('Role Selection Page'), findsNothing);
    });

    testWidgets('Cancel keeps the user on the profile screen', (tester) async {
      await openProfileAndTapLogout(tester);

      await tester.tap(find.byKey(const ValueKey('cancel_logout_button')));
      await tester.pumpAndSettle();

      expect(find.text('Logout Confirmation'), findsNothing);
      expect(find.byType(ProfileSettingsScreen), findsOneWidget);
      expect(find.text('Role Selection Page'), findsNothing);
    });

    testWidgets('Confirm goes to role selection and clears the route stack',
        (tester) async {
      await openProfileAndTapLogout(tester);

      await tester.tap(find.byKey(const ValueKey('confirm_logout_button')));
      await tester.pumpAndSettle();

      expect(find.text('Role Selection Page'), findsOneWidget);
      expect(find.byType(ProfileSettingsScreen), findsNothing);
      // Nothing left underneath, so Back cannot return to a logged-in page.
      expect(navigatorKey.currentState!.canPop(), isFalse);
    });
  });
}
