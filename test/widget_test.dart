// This is a basic Flutter widget test for Finora app.

import 'package:flutter_test/flutter_test.dart';

import 'package:finora/main.dart';

void main() {
  testWidgets('Finora app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FinoraApp());

    // Verify that the app title is displayed.
    expect(find.text('Finora'), findsOneWidget);

    // Verify that there is a FloatingActionButton with 'Nova' label.
    expect(find.text('Nova'), findsOneWidget);

    // Verify navigation bar destinations.
    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Relatórios'), findsOneWidget);
    expect(find.text('Categorias'), findsOneWidget);
  });
}
