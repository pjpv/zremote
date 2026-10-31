
part of 'ssl_certificate_dname.dart';

class SslCertificateDName {
  String? CName;

  String? DName;

  String? OName;

  String? UName;
  SslCertificateDName(
      {this.CName = "", this.DName = "", this.OName = "", this.UName = ""});

  static SslCertificateDName? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = SslCertificateDName();
    instance.CName = map['CName'];
    instance.DName = map['DName'];
    instance.OName = map['OName'];
    instance.UName = map['UName'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "CName": CName,
      "DName": DName,
      "OName": OName,
      "UName": UName,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'SslCertificateDName{CName: $CName, DName: $DName, OName: $OName, UName: $UName}';
  }
}
