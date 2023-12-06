import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medrecs/views/medView/AllergyFormScreen.dart';

void main() {
  testWidgets('AllergyFormScreen Input Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: AllergyFormScreen(userID: 200100300), // Replace 1 with the actual user ID
      ),
    );

    // Enter valid user ID
    await tester.enterText(find.byKey(Key('user_id_input')), '100200310');
    await tester.pump();

    // Enter valid allergy
    await tester.enterText(find.byKey(Key('allergy_input')), 'Pollen');
    await tester.pump();

    // Tap the date picker to select a date
    await tester.tap(find.byKey(Key('date_picker')));
    await tester.pumpAndSettle();

    // Tap on a specific date in the date picker
    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    // Enter valid treatment
    await tester.enterText(find.byKey(Key('treatment_input')), 'Antihistamines');
    await tester.pump();

    // Tap the submit button
    await tester.tap(find.text('Submit Allergy Data'));
    await tester.pump();

    // Add expectations for the expected behavior after tapping the submit button
    expect(find.text('Allergy Data submitted successfully!'), findsOneWidget);
  });
}
