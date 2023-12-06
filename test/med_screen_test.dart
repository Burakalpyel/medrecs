import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/views/medView/MedTeamScreen.dart';
import 'package:medrecs/views/medView/AppointmentFormScreen.dart';

void main() {
  testWidgets('Widget Initialization Test - MedTeamScreen', (WidgetTester tester) async {
    // Build our MedTeamScreen widget and trigger a frame
    final medTeamScreenWidget = MedTeamScreen(
      userID: 1, // replace with appropriate user ID for testing
      userInfo: PatientInfo(name: '', surname: '', birthday: '', address: '', location: '', phone: '', medteamstatus: true, password: ''), // replace with appropriate PatientInfo object for testing
    );
    await tester.pumpWidget(MaterialApp(home: medTeamScreenWidget));

    // Wait for all asynchronous operations to complete
    await tester.pumpAndSettle();

    // Verify the initial state of certain UI elements in MedTeamScreen
    expect(find.text("${medTeamScreenWidget.userInfo.name} ${medTeamScreenWidget.userInfo.surname}'s Area"), findsOneWidget);
    expect(find.text("Personal Details"), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byType(InkWell), findsNWidgets(2)); // Number of InkWells
  });

  testWidgets('Appointment Form Screen Renders Correctly', (WidgetTester tester) async {
    // Build the AppointmentFormScreen widget and trigger a frame
    final appointmentFormScreenWidget = AppointmentFormScreen();
    await tester.pumpWidget(MaterialApp(home: appointmentFormScreenWidget));

    // Expectations for AppointmentFormScreen initialization
    expect(find.text('Appointment Form'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(6)); // Number of TextFormFields
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
