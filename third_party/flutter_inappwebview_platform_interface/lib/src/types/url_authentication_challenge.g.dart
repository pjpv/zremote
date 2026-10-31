
part of 'url_authentication_challenge.dart';

class URLAuthenticationChallenge {
  URLProtectionSpace protectionSpace;
  URLAuthenticationChallenge({required this.protectionSpace});

  static URLAuthenticationChallenge? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = URLAuthenticationChallenge(
      protectionSpace: URLProtectionSpace.fromMap(
          map['protectionSpace']?.cast<String, dynamic>())!,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "protectionSpace": protectionSpace.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'URLAuthenticationChallenge{protectionSpace: $protectionSpace}';
  }
}
