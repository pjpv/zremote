
part of 'web_message.dart';

class WebMessageType {
  final int _value;
  final int _nativeValue;
  const WebMessageType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory WebMessageType._internalMultiPlatform(
          int value, Function nativeValue) =>
      WebMessageType._internal(value, nativeValue());

  static const ARRAY_BUFFER = WebMessageType._internal(1, 1);

  static const STRING = WebMessageType._internal(0, 0);

  static final Set<WebMessageType> values = [
    WebMessageType.ARRAY_BUFFER,
    WebMessageType.STRING,
  ].toSet();

  static WebMessageType? fromValue(int? value) {
    if (value != null) {
      try {
        return WebMessageType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static WebMessageType? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return WebMessageType.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  int toValue() => _value;

  int toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    switch (_value) {
      case 1:
        return 'ARRAY_BUFFER';
      case 0:
        return 'STRING';
    }
    return _value.toString();
  }
}

class WebMessage {
  dynamic data;

  List<IWebMessagePort>? ports;

  WebMessageType type;
  WebMessage({this.data, this.type = WebMessageType.STRING, this.ports}) {
    assert(((this.data == null || this.data is String) &&
            this.type == WebMessageType.STRING) ||
        (this.data != null &&
            this.data is Uint8List &&
            this.type == WebMessageType.ARRAY_BUFFER));
  }

  static WebMessage? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebMessage(
      data: map['data'],
      ports: map['ports'] != null
          ? List<IWebMessagePort>.from(map['ports'].map((e) => e))
          : null,
      type: WebMessageType.fromNativeValue(map['type'])!,
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "data": data,
      "ports": ports?.map((e) => e.toMap()).toList(),
      "type": type.toNativeValue(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'WebMessage{data: $data, ports: $ports, type: $type}';
  }
}
