import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physio_ghar_app/main.dart'; // Make sure this matches your package name if different

void main() {
  testWidgets('PhysioGhar app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame wrapped in ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: PhysioGharApp(),
      ),
    );

    // Verify that the app loads successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}