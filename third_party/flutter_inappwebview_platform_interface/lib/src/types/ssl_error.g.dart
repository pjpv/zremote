
part of 'ssl_error.dart';

class SslError {
  @Deprecated('Use code instead')
  AndroidSslError? androidError;

  SslErrorType? code;

  @Deprecated('Use code instead')
  IOSSslError? iosError;

  String? message;
  SslError(
      {@Deprecated('Use code instead') this.androidError,
      this.code,
      @Deprecated('Use code instead') this.iosError,
      this.message}) {
    code = code ?? SslErrorType.fromNativeValue(androidError?.toNativeValue());
    code = code ?? SslErrorType.fromNativeValue(iosError?.toNativeValue());
  }

  static SslError? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = SslError(
      androidError: AndroidSslError.fromNativeValue(map['code']),
      code: SslErrorType.fromNativeValue(map['code']),
      iosError: IOSSslError.fromNativeValue(map['code']),
      message: map['message'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "code": code?.toNativeValue(),
      "message": message,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'SslError{code: $code, message: $message}';
  }
}
