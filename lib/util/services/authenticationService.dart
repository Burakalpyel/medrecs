import 'package:local_auth/local_auth.dart';

class AuthenticationService {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  late LocalAuthentication localAuthentication = LocalAuthentication();

  void setLocalAuthentication(LocalAuthentication localAuthentication) {
    localAuthentication = localAuthentication;
  }

  Future<bool> authenticateIsAvailable() async {
    final isAvailable = await localAuthentication.canCheckBiometrics;
    final isDeviceSupported = await localAuthentication.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  Future<bool> authenticate() async {
    try {
      // Authenticate with biometrics
      return await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to continue',
      ); // Reason for authentication
    } catch (e) {
      return false;
    }
  }
}
