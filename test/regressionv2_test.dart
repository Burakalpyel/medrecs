import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:medrecs/util/services/authenticationService.dart';
import 'package:mockito/mockito.dart';

class MockLocalAuthentication extends Mock implements LocalAuthentication {}

void main() {
  group('AuthenticationService', () {
    late AuthenticationService authService;
    late MockLocalAuthentication mockLocalAuth;

    setUp(() {
      mockLocalAuth = MockLocalAuthentication();
      authService = AuthenticationService();
      authService.setLocalAuthentication(mockLocalAuth);
    });

    test('Successful authentication', () async {
      // Mock canCheckBiometrics
      when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) => Future.value(true));

      // Mock authenticate method
      final stub = when(mockLocalAuth.authenticate(
        localizedReason: anyNamed('localizedReason') ?? '',
      ));

      // Define the response to the mocked method call
      stub.thenAnswer((invocation) => Future.value(true));

      // Perform authentication
      bool result = await authService.authenticate();

      // Verify that authenticate method was called
      verify(mockLocalAuth.authenticate(
        localizedReason: 'Authenticate to continue',
      )).called(1);

      // Verify the result
      expect(result, true);
    });

    test('Biometrics not available', () async {
      // Mock canCheckBiometrics
      when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) => Future.value(false));

      // Perform authentication
      bool result = await authService.authenticate();

      // Verify that authenticate method was not called
      verifyNever(mockLocalAuth.authenticate(
        localizedReason: 'Authenticate to continue',
      ));

      // Verify the result
      expect(result, false);
    });

    test('Error during authentication', () async {
      // Mock canCheckBiometrics
      when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) => Future.value(true));

      // Mock authenticate method to throw an error
      final stub = when(mockLocalAuth.authenticate(
        localizedReason: anyNamed('localizedReason') ?? '',
      ));

      // Define the response to the mocked method call
      stub.thenThrow(Exception('Test error'));

      // Perform authentication
      bool result = await authService.authenticate();

      // Verify that authenticate method was called
      verify(mockLocalAuth.authenticate(
        localizedReason: 'Authenticate to continue',
      )).called(1);

      // Verify the result
      expect(result, false);
    });
  });
}
