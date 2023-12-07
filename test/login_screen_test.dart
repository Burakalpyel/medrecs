import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medrecs/views/commonView/login_screen.dart';

void main() {
  testWidgets('Show Invalid Password Dialog Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(), // Create an instance of LoginScreen
      ),
    );
    //This test checks if the LoginScreen widget properly displays an error message when the password is wrong.
    //It first creates the LoginScreen widget and finds its state to interact with it.
    //Then, it triggers the display of the error message for an invalid password.
    // The test verifies that the error message appears correctly and has an 'OK' button.
    //It simulates tapping the 'OK' button to dismiss the error message.
    // After that, it checks if the error message disappears as expected.

    // Get the state of the LoginScreen
    final loginScreenState = tester.state<LoginScreenState>(find.byType(LoginScreen));

    // Call the _showInvalidPasswordDialog method
    loginScreenState.showInvalidPasswordDialog();

    await tester.pump();

    // Verify that the dialog is displayed
    expect(find.text('Invalid Password'), findsOneWidget);
    expect(find.text('The password is incorrect. Please try again.'), findsOneWidget);

    // Verify the presence of the OK button in the dialog
    expect(find.text('OK'), findsOneWidget);

    // Close the dialog by tapping the OK button
    await tester.tap(find.text('OK'));
    await tester.pump();

    // Verify that the dialog is dismissed
    expect(find.text('Invalid Password'), findsNothing);
    expect(find.text('The password is incorrect. Please try again.'), findsNothing);
  });
  // this test ensures the proper display of a dialog in case of empty fields.
  //After triggering the dialog, it rebuilds the widget and verifies the presence of specific text elements.
  //Such as ('Empty Fields' and 'Please fill in both UserID and Password fields.') along with the 'OK' button within the dialog.
  testWidgets('Show Empty Field Dialog Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(), // Create an instance of LoginScreen
      ),
    );

    // Get the state of the LoginScreen
    final loginScreenState = tester.state<LoginScreenState>(find.byType(LoginScreen));

    // Call the _showEmptyFieldDialog method
    loginScreenState.showEmptyFieldDialog();

    await tester.pump(); // Rebuild the widget after calling the method

    // Verify that the dialog is displayed
    expect(find.text('Empty Fields'), findsOneWidget);
    expect(find.text('Please fill in both UserID and Password fields.'), findsOneWidget);

    // Verify the presence of the OK button in the dialog
    expect(find.text('OK'), findsOneWidget);

    // Close the dialog by tapping the OK button
    await tester.tap(find.text('OK'));
    await tester.pump();

    // Verify that the dialog is dismissed
    expect(find.text('Empty Fields'), findsNothing);
    expect(find.text('Please fill in both UserID and Password fields.'), findsNothing);
  });
}
