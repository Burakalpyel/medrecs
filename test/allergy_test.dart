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
    await tester.pumpAndSettle();

    // Enter valid allergy
    await tester.enterText(find.byKey(Key('allergy_input')), 'Pollen');
    await tester.pumpAndSettle();

    // Tap the date picker to select a date
    await tester.tap(find.byKey(Key('date_picker')));
    await tester.pumpAndSettle();

    // Tap on a specific date in the date picker
    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('OK')); // Replace with the actual text on your "OK" button
    await tester.pumpAndSettle();// Pump and settle to update the widget tree

    // Enter valid treatment
    await tester.enterText(find.byKey(Key('treatment_input')), 'Antihistamines');
    await tester.pumpAndSettle();

    // Tap the submit button
    await tester.tap(find.byKey(Key('submit_button')));
    await tester.pumpAndSettle();

    await tester.pumpAndSettle(Duration(milliseconds: 100));

    expect(find.byKey(Key('confirm_key')), findsNothing);

  });
}
