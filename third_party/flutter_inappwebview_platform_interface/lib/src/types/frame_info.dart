import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'url_request.dart';
import 'security_origin.dart';

part 'frame_info.g.dart';

@ExchangeableObject()
class FrameInfo_ {
  bool isMainFrame;

  URLRequest_? request;

  SecurityOrigin_? securityOrigin;

  FrameInfo_(
      {required this.isMainFrame, required this.request, this.securityOrigin});
}

@Deprecated("Use FrameInfo instead")
@ExchangeableObject()
class IOSWKFrameInfo_ {
  bool isMainFrame;

  URLRequest_? request;

  IOSWKSecurityOrigin_? securityOrigin;

  IOSWKFrameInfo_(
      {required this.isMainFrame, required this.request, this.securityOrigin});
}
