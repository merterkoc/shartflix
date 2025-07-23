import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shartflix/core/widget/text_field/app_password_field.dart';

void main() {
  testWidgets('AppPasswordField shows hint and toggles obscure', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppPasswordField(
            controller: controller,
            hintText: 'Password',
          ),
        ),
      ),
    );
    expect(find.text('Password'), findsOneWidget);
    expect(
      find.byIcon(Icons.lock),
      findsNothing,
    );
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.obscureText, isTrue);
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();
    final textFieldAfter = tester.widget<TextField>(find.byType(TextField));
    expect(textFieldAfter.obscureText, isFalse);
    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();
    final textFieldAgain = tester.widget<TextField>(find.byType(TextField));
    expect(textFieldAgain.obscureText, isTrue);
  });
}
