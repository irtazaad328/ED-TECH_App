import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// NOTE: 'flutterdemo' must match the "name:" line at the top of pubspec.yaml
import 'package:flutterdemo/routes/app_routes.dart';
import 'package:flutterdemo/screens/teacher/teacher_dashboard_screen.dart';

// Builds the dashboard inside a MaterialApp with a fake Cart Management page,
// so we can test navigation without needing the real screen.
Widget _buildApp() {
  return MaterialApp(
    home: const TeacherDashboardScreen(),
    routes: {
      AppRoutes.cartManagement: (_) => const Scaffold(
            body: Center(child: Text('Cart Management Stub')),
          ),
    },
  );
}

void main() {
  // Start every test from the "first load" numbers
  setUp(() => DashboardService.reset());

  // Make the test screen tall so nothing is off-screen
  void useTallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('shows a loading spinner first, then the dashboard',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(_buildApp());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Overview'), findsOneWidget);
  });

  testWidgets('displays the 3 KPI metric cards with correct values',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(_buildApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Total Earnings'), findsOneWidget);
    expect(find.text('\$12,450'), findsOneWidget);

    expect(find.text('Active Students'), findsOneWidget);
    expect(find.text('1,280'), findsOneWidget);

    expect(find.text('Course Rating'), findsOneWidget);
    expect(find.text('4.8 ★'), findsOneWidget);
  });

  testWidgets('shows the enrollment performance section with 4 progress bars',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(_buildApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Enrollment Performance'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNWidgets(4));
  });

  testWidgets('tapping Cart & Enrollment Management opens Cart Management',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(_buildApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    final tile = find.text('Cart & Enrollment Management');
    await tester.ensureVisible(tile);
    await tester.tap(tile);
    await tester.pumpAndSettle();

    expect(find.text('Cart Management Stub'), findsOneWidget);
  });
}
