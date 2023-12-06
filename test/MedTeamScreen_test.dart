import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medrecs/util/model/patientinfo.dart';
import 'package:medrecs/util/model/user_data.dart';
import 'package:medrecs/views/medView/MedTeamScreen.dart';
import 'package:provider/provider.dart';

class MockPatientInfo extends PatientInfo {
  MockPatientInfo()
      : super(
    name: 'John',
    surname: 'Doe',
    birthday: '01/01/1990',
    address: '123 Main St',
    location: 'City',
    phone: '555-1234',
    medteamstatus: true,
    password: 'mock_password',
  );
}

void main() {
  testWidgets('Widget Initialization Test', (WidgetTester tester) async {
    // Build our MedTeamScreen widget and trigger a frame
    final widget = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserData()), // Add other providers if needed
      ],
      child: MedTeamScreen(
        userID: 1, // replace with appropriate user ID for testing
        userInfo: MockPatientInfo(), // use the mock/stub for testing
      ),
    );

    await tester.pumpWidget(MaterialApp(home: widget));

    // Wait for all asynchronous operations to complete
    await tester.pumpAndSettle();

    // Verify the initial state of certain UI elements
    expect(find.text("Personal Details"), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byType(InkWell), findsNWidgets(2)); // Number of InkWells
  });
}
