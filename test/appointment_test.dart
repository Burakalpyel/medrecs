import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medrecs/views/medView/AppointmentFormScreen.dart';

void main() {
  testWidgets('AppointmentFormScreen Input Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: AppointmentFormScreen(userID: 200100300), // Replace 1 with the actual user ID
      ),
    );

    // Enter valid user ID
    await tester.enterText(find.byKey(Key('user_id_input')), '100200310');
    await tester.pumpAndSettle();

    // Enter valid doctor ID
    await tester.enterText(find.byKey(Key('doctor_id_input')), '200100300');
    await tester.pumpAndSettle();

    // Enter valid medical center ID
    await tester.enterText(find.byKey(Key('medical_center_id_input')), '789');
    await tester.pumpAndSettle();

    // Enter valid reason
    await tester.enterText(find.byKey(Key('reason_input')), 'Regular checkup');
    await tester.pumpAndSettle();

    // Tap the date picker to select a date
    await tester.tap(find.byKey(Key('date_picker')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('OK')); // Replace with the actual text on your "OK" button
    await tester.pumpAndSettle();// Pump and settle to update the widget tree

    // Tap the time picker to select a time
    await tester.tap(find.byKey(Key('time_picker')));
    await tester.pumpAndSettle(); // Wait for animations to complete

    await tester.tap(find.text('OK')); // Replace with the actual text on your "OK" button
    await tester.pumpAndSettle();// Pump and settle to update the widget tree

    // Tap the submit button
    await tester.tap(find.text('Submit Appointment Data'));
    await tester.pumpAndSettle();

    await tester.pumpAndSettle(Duration(milliseconds: 200));

    // Add expectations for the expected behavior after tapping the submit button
    expect(find.byKey(Key('confirmation')), findsNothing);
  });
}
