import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'ssl_certificate.dart';

part 'ssl_certificate_dname.g.dart';

@ExchangeableObject()
class SslCertificateDName_ {
  String? CName;

  String? DName;

  String? OName;

  String? UName;

  SslCertificateDName_(
      {this.CName = "", this.DName = "", this.OName = "", this.UName = ""});
}
