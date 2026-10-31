
part of 'client_cert_response.dart';

class ClientCertResponse {
  ClientCertResponseAction? action;

  @Deprecated('Use keyStoreType instead')
  String? androidKeyStoreType;

  String? certificatePassword;

  String certificatePath;

  String? keyStoreType;
  ClientCertResponse(
      {required this.certificatePath,
      this.certificatePassword = "",
      @Deprecated('Use keyStoreType instead')
      this.androidKeyStoreType = "PKCS12",
      this.keyStoreType = "PKCS12",
      this.action = ClientCertResponseAction.CANCEL}) {
    if (this.action == ClientCertResponseAction.PROCEED)
      assert(certificatePath.isNotEmpty);
    this.keyStoreType = this.keyStoreType ?? this.androidKeyStoreType;
    if (Util.isAndroid) assert(this.keyStoreType != null);
  }

  static ClientCertResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ClientCertResponse(
      certificatePath: map['certificatePath'],
    );
    instance.action = ClientCertResponseAction.fromNativeValue(map['action']);
    instance.androidKeyStoreType = map['keyStoreType'];
    instance.certificatePassword = map['certificatePassword'];
    instance.keyStoreType = map['keyStoreType'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "action": action?.toNativeValue(),
      "certificatePassword": certificatePassword,
      "certificatePath": certificatePath,
      "keyStoreType": keyStoreType,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ClientCertResponse{action: $action, certificatePassword: $certificatePassword, certificatePath: $certificatePath, keyStoreType: $keyStoreType}';
  }
}
