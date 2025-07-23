import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shartflix/core/widget/text_field/app_text_field.dart';

void main() {
  testWidgets('AppTextField shows hint and prefix icon', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(
            controller: controller,
            hintText: 'E-mail',
            prefixIcon: const Icon(Icons.email),
          ),
        ),
      ),
    );
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.byIcon(Icons.email), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'test@example.com');
    expect(controller.text, 'test@example.com');
  });
}
