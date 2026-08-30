import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  BiometricService._() : _auth = LocalAuthentication();

  @visibleForTesting
  BiometricService.forTesting(LocalAuthentication auth) : _auth = auth;

  static final BiometricService instance = BiometricService._();

  final LocalAuthentication _auth;

  DateTime? _lastSuccess;

  DateTime? get lastSuccessAt => _lastSuccess;

  static const cancelCodes = {
    LocalAuthExceptionCode.userCanceled,
    LocalAuthExceptionCode.systemCanceled,
    LocalAuthExceptionCode.timeout,
    LocalAuthExceptionCode.userRequestedFallback,
    LocalAuthExceptionCode.authInProgress,
  };

  static const unavailableCodes = {
    LocalAuthExceptionCode.noCredentialsSet,
    LocalAuthExceptionCode.noBiometricsEnrolled,
    LocalAuthExceptionCode.noBiometricHardware,
    LocalAuthExceptionCode.uiUnavailable,
  };

  Future<bool> isAvailable() async {
    final canBio = await _auth.canCheckBiometrics;
    final supported = await _auth.isDeviceSupported();
    return canBio || supported;
  }

  Future<bool> authenticate(String reason) async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      if (ok) _lastSuccess = DateTime.now();
      return ok;
    } on LocalAuthException catch (e) {
      if (cancelCodes.contains(e.code)) return false;
      if (unavailableCodes.contains(e.code)) {
        throw BiometricUnavailableException(e);
      }
      rethrow;
    }
  }
}

class BiometricUnavailableException implements Exception {
  const BiometricUnavailableException(this.cause);

  final LocalAuthException cause;

  @override
  String toString() => cause.toString();
}
