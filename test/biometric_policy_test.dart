import 'package:local_auth/local_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart'
    show AuthMessages;
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/services/biometric.dart';

class _ScriptedAuth extends LocalAuthentication {
  _ScriptedAuth(this._script);

  final Object Function() _script;

  @override
  Future<bool> authenticate({
    required String localizedReason,
    Iterable<AuthMessages> authMessages = const <AuthMessages>[],
    bool biometricOnly = false,
    bool sensitiveTransaction = true,
    bool persistAcrossBackgrounding = false,
  }) async {
    final result = _script();
    if (result is bool) return result;
    throw result;
  }
}

BiometricService _service(Object Function() script) =>
    BiometricService.forTesting(_ScriptedAuth(script));

void main() {
  test('取消族异常一律转为 false（不得当作故障改变开关状态）', () async {
    for (final code in const [
      LocalAuthExceptionCode.userCanceled,
      LocalAuthExceptionCode.systemCanceled,
      LocalAuthExceptionCode.timeout,
      LocalAuthExceptionCode.userRequestedFallback,
      LocalAuthExceptionCode.authInProgress,
    ]) {
      final svc = _service(() => LocalAuthException(code: code));
      expect(await svc.authenticate('r'), isFalse, reason: '$code 应视为未通过');
    }
  });

  test('凭据永久不可用族包装为 BiometricUnavailableException', () async {
    for (final code in const [
      LocalAuthExceptionCode.noCredentialsSet,
      LocalAuthExceptionCode.noBiometricsEnrolled,
      LocalAuthExceptionCode.noBiometricHardware,
      LocalAuthExceptionCode.uiUnavailable,
    ]) {
      final svc = _service(() => LocalAuthException(code: code));
      await expectLater(
        svc.authenticate('r'),
        throwsA(isA<BiometricUnavailableException>()),
        reason: '$code 应标记为不可用',
      );
    }
  });

  test('临时锁定与未知故障原样上抛（可重试，不得强制关锁）', () async {
    for (final code in const [
      LocalAuthExceptionCode.temporaryLockout,
      LocalAuthExceptionCode.biometricLockout,
      LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable,
      LocalAuthExceptionCode.deviceError,
      LocalAuthExceptionCode.unknownError,
    ]) {
      final svc = _service(() => LocalAuthException(code: code));
      await expectLater(
        svc.authenticate('r'),
        throwsA(isA<LocalAuthException>()),
        reason: '$code 应原样上抛',
      );
    }
  });

  test('验证通过返回 true 并记录成功时刻', () async {
    final svc = _service(() => true);
    expect(await svc.authenticate('r'), isTrue);
    expect(svc.lastSuccessAt, isNotNull);
  });

  test('验证未通过返回 false 且不记录成功时刻', () async {
    final svc = _service(() => false);
    expect(await svc.authenticate('r'), isFalse);
    expect(svc.lastSuccessAt, isNull);
  });
}
