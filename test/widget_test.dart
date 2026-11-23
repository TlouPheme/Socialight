import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:socialight/data/mock_data.dart';
import 'package:socialight/screens/interests_screen.dart';
import 'package:socialight/screens/home_shell.dart';
import 'package:socialight/screens/login_screen.dart';
import 'package:socialight/screens/quests_screen.dart';
import 'package:socialight/widgets/controls.dart';
import 'package:socialight/widgets/sky.dart';

// Pump screens without the Google Fonts theme so tests don't hit the network.
Widget wrap(Widget home) => MaterialApp(home: home);

PillButton pill(WidgetTester tester, String label) =>
    tester.widget<PillButton>(find.widgetWithText(PillButton, label));

void main() {
  setUp(() {
    appState.signOut();
    CloudLayer.animate = false;
  });

  testWidgets('login is enabled once email and password are filled', (tester) async {
    tester.view.physicalSize = const Size(393, 852) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrap(const LoginScreen()));
    expect(pill(tester, 'Login').onPressed, isNull);

    await tester.enterText(find.byType(TextField).at(0), 'izi@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret');
    await tester.pump();
    expect(pill(tester, 'Login').onPressed, isNotNull);

    await tester.tap(find.text('Login').last);
    await tester.pumpAndSettle();
    expect(find.byType(HomeShell), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(appState.displayName, 'izi');
  });

  testWidgets('interests: Next unlocks after selecting one', (tester) async {
    tester.view.physicalSize = const Size(393, 852) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrap(const InterestsScreen()));
    expect(pill(tester, 'Next').onPressed, isNull);
    await tester.tap(find.text('Hiking'));
    await tester.pump();
    expect(pill(tester, 'Next').onPressed, isNotNull);
  });

  testWidgets('completing a quest requires an image and awards XP', (tester) async {
    tester.view.physicalSize = const Size(393, 852) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrap(const QuestsScreen()));
    await tester.tap(find.text(quests.first.title));
    await tester.pumpAndSettle();

    await tester.tap(find.text('View on map'));
    await tester.pumpAndSettle();
    expect(pill(tester, 'Quest Completed').onPressed, isNull);
    Navigator.of(tester.element(find.text('Map'))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Upload Image'));
    await tester.pumpAndSettle();
    expect(find.text('Photo uploaded · finish on the map'), findsOneWidget);
    await tester.tap(find.text('Finish on the map'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Quest Completed'));
    await tester.pumpAndSettle();
    expect(find.text('Quest complete!'), findsOneWidget);
    await tester.tap(find.text('Awesome!'));
    await tester.pumpAndSettle();
    expect(find.text('Completed'), findsOneWidget);
    expect(appState.xp, quests.first.xp);
    expect(appState.completedQuests, contains(quests.first.id));
  });
}
