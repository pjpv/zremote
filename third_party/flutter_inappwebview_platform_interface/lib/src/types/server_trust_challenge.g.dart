
part of 'server_trust_challenge.dart';

class ServerTrustChallenge extends URLAuthenticationChallenge {
  ServerTrustChallenge({required URLProtectionSpace protectionSpace})
      : super(protectionSpace: protectionSpace);

  static ServerTrustChallenge? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ServerTrustChallenge(
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
    return 'ServerTrustChallenge{protectionSpace: $protectionSpace}';
  }
}
