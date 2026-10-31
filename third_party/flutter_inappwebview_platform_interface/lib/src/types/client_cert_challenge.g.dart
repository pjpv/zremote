
part of 'client_cert_challenge.dart';

class ClientCertChallenge extends URLAuthenticationChallenge {
  @Deprecated('Use keyTypes instead')
  List<String>? androidKeyTypes;

  @Deprecated('Use principals instead')
  List<String>? androidPrincipals;

  List<String>? keyTypes;

  List<String>? principals;
  ClientCertChallenge(
      {@Deprecated('Use keyTypes instead') this.androidKeyTypes,
      @Deprecated('Use principals instead') this.androidPrincipals,
      this.keyTypes,
      this.principals,
      required URLProtectionSpace protectionSpace})
      : super(protectionSpace: protectionSpace) {
    keyTypes = keyTypes ?? androidKeyTypes;
    principals = principals ?? androidPrincipals;
  }

  static ClientCertChallenge? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ClientCertChallenge(
      protectionSpace: URLProtectionSpace.fromMap(
          map['protectionSpace']?.cast<String, dynamic>())!,
      androidKeyTypes: map['keyTypes'] != null
          ? List<String>.from(map['keyTypes']!.cast<String>())
          : null,
      androidPrincipals: map['principals'] != null
          ? List<String>.from(map['principals']!.cast<String>())
          : null,
      keyTypes: map['keyTypes'] != null
          ? List<String>.from(map['keyTypes']!.cast<String>())
          : null,
      principals: map['principals'] != null
          ? List<String>.from(map['principals']!.cast<String>())
          : null,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "protectionSpace": protectionSpace.toMap(),
      "keyTypes": keyTypes,
      "principals": principals,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ClientCertChallenge{protectionSpace: $protectionSpace, keyTypes: $keyTypes, principals: $principals}';
  }
}
