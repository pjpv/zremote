
part of 'security_origin.dart';

class SecurityOrigin {
  String host;

  int port;

  String protocol;
  SecurityOrigin(
      {required this.host, required this.port, required this.protocol});

  static SecurityOrigin? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = SecurityOrigin(
      host: map['host'],
      port: map['port'],
      protocol: map['protocol'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "host": host,
      "port": port,
      "protocol": protocol,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'SecurityOrigin{host: $host, port: $port, protocol: $protocol}';
  }
}

@Deprecated('Use SecurityOrigin instead')
class IOSWKSecurityOrigin {
  String host;

  int port;

  String protocol;
  IOSWKSecurityOrigin(
      {required this.host, required this.port, required this.protocol});

  static IOSWKSecurityOrigin? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = IOSWKSecurityOrigin(
      host: map['host'],
      port: map['port'],
      protocol: map['protocol'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "host": host,
      "port": port,
      "protocol": protocol,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'IOSWKSecurityOrigin{host: $host, port: $port, protocol: $protocol}';
  }
}
