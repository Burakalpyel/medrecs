import 'package:local_auth/local_auth.dart';

class AuthenticationService {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      // Check if biometrics are available
      bool isAvailable = await _localAuthentication.canCheckBiometrics;

      if (!isAvailable) {
        // Biometrics not available on this device
        return false;
      }

      // Authenticate with biometrics
      bool isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to continue', // Reason for authentication
      );

      return isAuthenticated;
    } catch (e) {
      print('Error during authentication: $e');
      return false;
    }
  }
}
