
part of 'ssl_error_type.dart';

class SslErrorType {
  final String _value;
  final int? _nativeValue;
  const SslErrorType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory SslErrorType._internalMultiPlatform(
          String value, Function nativeValue) =>
      SslErrorType._internal(value, nativeValue());

  static final DATE_INVALID =
      SslErrorType._internalMultiPlatform('DATE_INVALID', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 4;
      default:
        break;
    }
    return null;
  });

  static final DENY = SslErrorType._internalMultiPlatform('DENY', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 3;
      case TargetPlatform.macOS:
        return 3;
      default:
        break;
    }
    return null;
  });

  static final EXPIRED = SslErrorType._internalMultiPlatform('EXPIRED', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 1;
      default:
        break;
    }
    return null;
  });

  static final FATAL_TRUST_FAILURE =
      SslErrorType._internalMultiPlatform('FATAL_TRUST_FAILURE', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 6;
      case TargetPlatform.macOS:
        return 6;
      default:
        break;
    }
    return null;
  });

  static final IDMISMATCH =
      SslErrorType._internalMultiPlatform('IDMISMATCH', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 2;
      default:
        break;
    }
    return null;
  });

  static final INVALID = SslErrorType._internalMultiPlatform('INVALID', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 5;
      case TargetPlatform.iOS:
        return 0;
      case TargetPlatform.macOS:
        return 0;
      default:
        break;
    }
    return null;
  });

  static final NOT_YET_VALID =
      SslErrorType._internalMultiPlatform('NOT_YET_VALID', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 0;
      default:
        break;
    }
    return null;
  });

  static final OTHER_ERROR =
      SslErrorType._internalMultiPlatform('OTHER_ERROR', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 7;
      case TargetPlatform.macOS:
        return 7;
      default:
        break;
    }
    return null;
  });

  static final RECOVERABLE_TRUST_FAILURE =
      SslErrorType._internalMultiPlatform('RECOVERABLE_TRUST_FAILURE', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 5;
      case TargetPlatform.macOS:
        return 5;
      default:
        break;
    }
    return null;
  });

  static final UNSPECIFIED =
      SslErrorType._internalMultiPlatform('UNSPECIFIED', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 4;
      case TargetPlatform.macOS:
        return 4;
      default:
        break;
    }
    return null;
  });

  static final UNTRUSTED = SslErrorType._internalMultiPlatform('UNTRUSTED', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 3;
      default:
        break;
    }
    return null;
  });

  static final Set<SslErrorType> values = [
    SslErrorType.DATE_INVALID,
    SslErrorType.DENY,
    SslErrorType.EXPIRED,
    SslErrorType.FATAL_TRUST_FAILURE,
    SslErrorType.IDMISMATCH,
    SslErrorType.INVALID,
    SslErrorType.NOT_YET_VALID,
    SslErrorType.OTHER_ERROR,
    SslErrorType.RECOVERABLE_TRUST_FAILURE,
    SslErrorType.UNSPECIFIED,
    SslErrorType.UNTRUSTED,
  ].toSet();

  static SslErrorType? fromValue(String? value) {
    if (value != null) {
      try {
        return SslErrorType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static SslErrorType? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return SslErrorType.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String toValue() => _value;

  int? toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}

@Deprecated('Use SslErrorType instead')
class AndroidSslError {
  final int _value;
  final int _nativeValue;
  const AndroidSslError._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory AndroidSslError._internalMultiPlatform(
          int value, Function nativeValue) =>
      AndroidSslError._internal(value, nativeValue());

  static const SSL_DATE_INVALID = AndroidSslError._internal(4, 4);

  static const SSL_EXPIRED = AndroidSslError._internal(1, 1);

  static const SSL_IDMISMATCH = AndroidSslError._internal(2, 2);

  static const SSL_INVALID = AndroidSslError._internal(5, 5);

  static const SSL_NOTYETVALID = AndroidSslError._internal(0, 0);

  static const SSL_UNTRUSTED = AndroidSslError._internal(3, 3);

  static final Set<AndroidSslError> values = [
    AndroidSslError.SSL_DATE_INVALID,
    AndroidSslError.SSL_EXPIRED,
    AndroidSslError.SSL_IDMISMATCH,
    AndroidSslError.SSL_INVALID,
    AndroidSslError.SSL_NOTYETVALID,
    AndroidSslError.SSL_UNTRUSTED,
  ].toSet();

  static AndroidSslError? fromValue(int? value) {
    if (value != null) {
      try {
        return AndroidSslError.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static AndroidSslError? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return AndroidSslError.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  int toValue() => _value;

  int toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    switch (_value) {
      case 4:
        return 'SSL_DATE_INVALID';
      case 1:
        return 'SSL_EXPIRED';
      case 2:
        return 'SSL_IDMISMATCH';
      case 5:
        return 'SSL_INVALID';
      case 0:
        return 'SSL_NOTYETVALID';
      case 3:
        return 'SSL_UNTRUSTED';
    }
    return _value.toString();
  }
}

@Deprecated('Use SslErrorType instead')
class IOSSslError {
  final int _value;
  final int _nativeValue;
  const IOSSslError._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory IOSSslError._internalMultiPlatform(int value, Function nativeValue) =>
      IOSSslError._internal(value, nativeValue());

  static const DENY = IOSSslError._internal(3, 3);

  static const FATAL_TRUST_FAILURE = IOSSslError._internal(6, 6);

  static const INVALID = IOSSslError._internal(0, 0);

  static const OTHER_ERROR = IOSSslError._internal(7, 7);

  static const RECOVERABLE_TRUST_FAILURE = IOSSslError._internal(5, 5);

  static const UNSPECIFIED = IOSSslError._internal(4, 4);

  static final Set<IOSSslError> values = [
    IOSSslError.DENY,
    IOSSslError.FATAL_TRUST_FAILURE,
    IOSSslError.INVALID,
    IOSSslError.OTHER_ERROR,
    IOSSslError.RECOVERABLE_TRUST_FAILURE,
    IOSSslError.UNSPECIFIED,
  ].toSet();

  static IOSSslError? fromValue(int? value) {
    if (value != null) {
      try {
        return IOSSslError.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSSslError? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return IOSSslError.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  int toValue() => _value;

  int toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    switch (_value) {
      case 3:
        return 'DENY';
      case 6:
        return 'FATAL_TRUST_FAILURE';
      case 0:
        return 'INVALID';
      case 7:
        return 'OTHER_ERROR';
      case 5:
        return 'RECOVERABLE_TRUST_FAILURE';
      case 4:
        return 'UNSPECIFIED';
    }
    return _value.toString();
  }
}
