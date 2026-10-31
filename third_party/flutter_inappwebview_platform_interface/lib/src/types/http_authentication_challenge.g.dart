
part of 'http_authentication_challenge.dart';

class HttpAuthenticationChallenge extends URLAuthenticationChallenge {
  String? error;

  URLResponse? failureResponse;

  @Deprecated('Use error instead')
  String? iosError;

  @Deprecated('Use failureResponse instead')
  IOSURLResponse? iosFailureResponse;

  int previousFailureCount;

  URLCredential? proposedCredential;
  HttpAuthenticationChallenge(
      {this.error,
      this.failureResponse,
      @Deprecated('Use error instead') this.iosError,
      @Deprecated('Use failureResponse instead') this.iosFailureResponse,
      required this.previousFailureCount,
      this.proposedCredential,
      required URLProtectionSpace protectionSpace})
      : super(protectionSpace: protectionSpace) {
    error = error ?? iosError;
    failureResponse =
        failureResponse ?? URLResponse.fromMap(iosFailureResponse?.toMap());
  }

  static HttpAuthenticationChallenge? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = HttpAuthenticationChallenge(
      protectionSpace: URLProtectionSpace.fromMap(
          map['protectionSpace']?.cast<String, dynamic>())!,
      error: map['error'],
      failureResponse:
          URLResponse.fromMap(map['failureResponse']?.cast<String, dynamic>()),
      iosError: map['error'],
      iosFailureResponse: IOSURLResponse.fromMap(
          map['failureResponse']?.cast<String, dynamic>()),
      previousFailureCount: map['previousFailureCount'],
      proposedCredential: URLCredential.fromMap(
          map['proposedCredential']?.cast<String, dynamic>()),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "protectionSpace": protectionSpace.toMap(),
      "error": error,
      "failureResponse": failureResponse?.toMap(),
      "previousFailureCount": previousFailureCount,
      "proposedCredential": proposedCredential?.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'HttpAuthenticationChallenge{protectionSpace: $protectionSpace, error: $error, failureResponse: $failureResponse, previousFailureCount: $previousFailureCount, proposedCredential: $proposedCredential}';
  }
}
