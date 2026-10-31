
part of 'url_request.dart';

class URLRequest {
  bool? allowsCellularAccess;

  bool? allowsConstrainedNetworkAccess;

  bool? allowsExpensiveNetworkAccess;

  bool? assumesHTTP3Capable;

  URLRequestAttribution? attribution;

  Uint8List? body;

  URLRequestCachePolicy? cachePolicy;

  Map<String, String>? headers;

  bool? httpShouldHandleCookies;

  bool? httpShouldUsePipelining;

  @Deprecated('Use allowsCellularAccess instead')
  bool? iosAllowsCellularAccess;

  @Deprecated('Use allowsConstrainedNetworkAccess instead')
  bool? iosAllowsConstrainedNetworkAccess;

  @Deprecated('Use allowsExpensiveNetworkAccess instead')
  bool? iosAllowsExpensiveNetworkAccess;

  @Deprecated('Use cachePolicy instead')
  IOSURLRequestCachePolicy? iosCachePolicy;

  @Deprecated('Use httpShouldHandleCookies instead')
  bool? iosHttpShouldHandleCookies;

  @Deprecated('Use httpShouldUsePipelining instead')
  bool? iosHttpShouldUsePipelining;

  @Deprecated('Use mainDocumentURL instead')
  Uri? iosMainDocumentURL;

  @Deprecated('Use networkServiceType instead')
  IOSURLRequestNetworkServiceType? iosNetworkServiceType;

  @Deprecated('Use timeoutInterval instead')
  double? iosTimeoutInterval;

  WebUri? mainDocumentURL;

  String? method;

  URLRequestNetworkServiceType? networkServiceType;

  double? timeoutInterval;

  WebUri? url;
  URLRequest(
      {this.allowsCellularAccess,
      this.allowsConstrainedNetworkAccess,
      this.allowsExpensiveNetworkAccess,
      this.assumesHTTP3Capable,
      this.attribution,
      this.body,
      this.cachePolicy,
      this.headers,
      this.httpShouldHandleCookies,
      this.httpShouldUsePipelining,
      @Deprecated('Use allowsCellularAccess instead')
      this.iosAllowsCellularAccess,
      @Deprecated('Use allowsConstrainedNetworkAccess instead')
      this.iosAllowsConstrainedNetworkAccess,
      @Deprecated('Use allowsExpensiveNetworkAccess instead')
      this.iosAllowsExpensiveNetworkAccess,
      @Deprecated('Use cachePolicy instead') this.iosCachePolicy,
      @Deprecated('Use httpShouldHandleCookies instead')
      this.iosHttpShouldHandleCookies,
      @Deprecated('Use httpShouldUsePipelining instead')
      this.iosHttpShouldUsePipelining,
      @Deprecated('Use mainDocumentURL instead') this.iosMainDocumentURL,
      @Deprecated('Use networkServiceType instead') this.iosNetworkServiceType,
      @Deprecated('Use timeoutInterval instead') this.iosTimeoutInterval,
      this.mainDocumentURL,
      this.method,
      this.networkServiceType,
      this.timeoutInterval,
      this.url}) {
    allowsCellularAccess = allowsCellularAccess ?? iosAllowsCellularAccess;
    allowsConstrainedNetworkAccess =
        allowsConstrainedNetworkAccess ?? iosAllowsConstrainedNetworkAccess;
    allowsExpensiveNetworkAccess =
        allowsExpensiveNetworkAccess ?? iosAllowsExpensiveNetworkAccess;
    cachePolicy = cachePolicy ??
        URLRequestCachePolicy.fromNativeValue(iosCachePolicy?.toNativeValue());
    httpShouldHandleCookies =
        httpShouldHandleCookies ?? iosHttpShouldHandleCookies;
    httpShouldUsePipelining =
        httpShouldUsePipelining ?? iosHttpShouldUsePipelining;
    mainDocumentURL = mainDocumentURL ??
        (iosMainDocumentURL != null ? WebUri.uri(iosMainDocumentURL!) : null);
    networkServiceType = networkServiceType ??
        URLRequestNetworkServiceType.fromNativeValue(
            iosNetworkServiceType?.toNativeValue());
    timeoutInterval = timeoutInterval ?? iosTimeoutInterval;
  }

  static URLRequest? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = URLRequest(
      allowsCellularAccess: map['allowsCellularAccess'],
      allowsConstrainedNetworkAccess: map['allowsConstrainedNetworkAccess'],
      allowsExpensiveNetworkAccess: map['allowsExpensiveNetworkAccess'],
      assumesHTTP3Capable: map['assumesHTTP3Capable'],
      attribution: URLRequestAttribution.fromNativeValue(map['attribution']),
      body: map['body'] != null
          ? Uint8List.fromList(map['body'].cast<int>())
          : null,
      cachePolicy: URLRequestCachePolicy.fromNativeValue(map['cachePolicy']),
      headers: map['headers']?.cast<String, String>(),
      httpShouldHandleCookies: map['httpShouldHandleCookies'],
      httpShouldUsePipelining: map['httpShouldUsePipelining'],
      iosAllowsCellularAccess: map['allowsCellularAccess'],
      iosAllowsConstrainedNetworkAccess: map['allowsConstrainedNetworkAccess'],
      iosAllowsExpensiveNetworkAccess: map['allowsExpensiveNetworkAccess'],
      iosCachePolicy:
          IOSURLRequestCachePolicy.fromNativeValue(map['cachePolicy']),
      iosHttpShouldHandleCookies: map['httpShouldHandleCookies'],
      iosHttpShouldUsePipelining: map['httpShouldUsePipelining'],
      iosMainDocumentURL: map['mainDocumentURL'] != null
          ? Uri.tryParse(map['mainDocumentURL'])
          : null,
      iosNetworkServiceType: IOSURLRequestNetworkServiceType.fromNativeValue(
          map['networkServiceType']),
      iosTimeoutInterval: map['timeoutInterval'],
      mainDocumentURL: map['mainDocumentURL'] != null
          ? WebUri(map['mainDocumentURL'])
          : null,
      method: map['method'],
      networkServiceType: URLRequestNetworkServiceType.fromNativeValue(
          map['networkServiceType']),
      timeoutInterval: map['timeoutInterval'],
      url: map['url'] != null ? WebUri(map['url']) : null,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "allowsCellularAccess": allowsCellularAccess,
      "allowsConstrainedNetworkAccess": allowsConstrainedNetworkAccess,
      "allowsExpensiveNetworkAccess": allowsExpensiveNetworkAccess,
      "assumesHTTP3Capable": assumesHTTP3Capable,
      "attribution": attribution?.toNativeValue(),
      "body": body,
      "cachePolicy": cachePolicy?.toNativeValue(),
      "headers": headers,
      "httpShouldHandleCookies": httpShouldHandleCookies,
      "httpShouldUsePipelining": httpShouldUsePipelining,
      "mainDocumentURL": mainDocumentURL?.toString(),
      "method": method,
      "networkServiceType": networkServiceType?.toNativeValue(),
      "timeoutInterval": timeoutInterval,
      "url": url?.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'URLRequest{allowsCellularAccess: $allowsCellularAccess, allowsConstrainedNetworkAccess: $allowsConstrainedNetworkAccess, allowsExpensiveNetworkAccess: $allowsExpensiveNetworkAccess, assumesHTTP3Capable: $assumesHTTP3Capable, attribution: $attribution, body: $body, cachePolicy: $cachePolicy, headers: $headers, httpShouldHandleCookies: $httpShouldHandleCookies, httpShouldUsePipelining: $httpShouldUsePipelining, mainDocumentURL: $mainDocumentURL, method: $method, networkServiceType: $networkServiceType, timeoutInterval: $timeoutInterval, url: $url}';
  }
}
