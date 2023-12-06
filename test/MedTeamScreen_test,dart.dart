import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/views/medView/MedTeamScreen.dart';

void main() {
  testWidgets('Widget Initialization Test', (WidgetTester tester) async {
    // Build our MedTeamScreen widget and trigger a frame
    final widget = MedTeamScreen(
      userID: 1, // replace with appropriate user ID for testing
      userInfo: PatientInfo(name: '', surname: '', birthday: '', address: '', location: '', phone: '', medteamstatus: true, password: ''), // replace with appropriate PatientInfo object for testing
    );
    await tester.pumpWidget(MaterialApp(home: widget));

    // Wait for all asynchronous operations to complete
    await tester.pumpAndSettle();

    // Verify the initial state of certain UI elements
    expect(find.text("${widget.userInfo.name} ${widget.userInfo.surname}'s Area"), findsOneWidget);
    expect(find.text("Personal Details"), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byType(InkWell), findsNWidgets(2)); // Number of InkWells
  });
}