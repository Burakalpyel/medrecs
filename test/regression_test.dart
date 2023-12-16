import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:medrecs/util/services/authenticationService.dart';



void main() {
  test('authenticate() returns false when biometrics are unavailable', () async {
    // Simulate the absence of biometrics support
    final LocalAuthentication localAuthentication = LocalAuthentication();
    final AuthenticationService authService = AuthenticationService();

    bool isAuthenticated = await authService.authenticate();

    expect(isAuthenticated, isFalse);
  });

  test('authenticate() returns false when authentication fails', () async {
    // Simulate biometrics support but authentication failure
    final LocalAuthentication localAuthentication = LocalAuthentication();
    final AuthenticationService authService = AuthenticationService();

    bool isAuthenticated = await authService.authenticate();

    expect(isAuthenticated, isFalse);
  });

  test('authenticate() returns true when biometrics are available and authentication succeeds', () async {
    // Simulate biometrics support and successful authentication
    final LocalAuthentication localAuthentication = LocalAuthentication();
    final AuthenticationService authService = AuthenticationService();

    bool isAuthenticated = await authService.authenticate();

    expect(isAuthenticated, isTrue);
  });
}