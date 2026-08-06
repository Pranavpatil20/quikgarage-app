import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('QuikGarage branding placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('quikgarage'))),
      ),
    );
    expect(find.text('quikgarage'), findsOneWidget);
  });
}
