
part of 'custom_scheme_registration.dart';

class CustomSchemeRegistration {
  List<String>? allowedOrigins;

  bool? hasAuthorityComponent;

  String scheme;

  bool? treatAsSecure;

  CustomSchemeRegistration(
      {this.allowedOrigins,
      this.hasAuthorityComponent,
      required this.scheme,
      this.treatAsSecure});

  static CustomSchemeRegistration? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = CustomSchemeRegistration(
      allowedOrigins: map['allowedOrigins'] != null
          ? List<String>.from(map['allowedOrigins']!.cast<String>())
          : null,
      hasAuthorityComponent: map['hasAuthorityComponent'],
      scheme: map['scheme'],
      treatAsSecure: map['treatAsSecure'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "allowedOrigins": allowedOrigins,
      "hasAuthorityComponent": hasAuthorityComponent,
      "scheme": scheme,
      "treatAsSecure": treatAsSecure,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'CustomSchemeRegistration{allowedOrigins: $allowedOrigins, hasAuthorityComponent: $hasAuthorityComponent, scheme: $scheme, treatAsSecure: $treatAsSecure}';
  }
}
