import 'dart:convert';
import 'dart:typed_data';

abstract final class RpcCodec {
  static const String kScheduledModel =
      'custom:builtin%3Abigmodel-coding-plan:GLM-5.3';

  static int crc32(List<int> bytes) {
    var crc = 0xFFFFFFFF;
    for (final byte in bytes) {
      crc = (crc ^ (byte & 0xFF)) & 0xFFFFFFFF;
      for (var i = 0; i < 8; i++) {
        crc = (crc & 1) != 0 ? ((crc >> 1) ^ 0xEDB88320) : (crc >> 1);
      }
    }
    return (crc ^ 0xFFFFFFFF) & 0xFFFFFFFF;
  }

  static String crc32Hex(List<int> bytes) =>
      crc32(bytes).toRadixString(16).padLeft(8, '0');

  static void writeVarint(BytesBuilder b, int v) {
    var value = v;
    while (value >= 0x80) {
      b.addByte((value & 0x7F) | 0x80);
      value >>= 7;
    }
    b.addByte(value);
  }

  static (int, int) readVarint(Uint8List bytes, int offset) {
    var value = 0;
    var shift = 0;
    while (true) {
      if (offset >= bytes.length) {
        throw const FormatException('truncated varint');
      }
      final byte = bytes[offset++];
      value |= (byte & 0x7F) << shift;
      if ((byte & 0x80) == 0) return (value, offset);
      shift += 7;
    }
  }

  static void _writeLenString(BytesBuilder b, String s) {
    final bytes = utf8.encode(s);
    writeVarint(b, bytes.length);
    b.add(bytes);
  }

  static String buildRpcEnvelope({
    required String bridgeSessionId,
    required int bridgeGeneration,
    required int seq,
    required String channel,
    required String method,
    Object? params,
  }) {
    final b = BytesBuilder();
    b.add(const [0x04, 0x04]);
    b.add(const [0x06, 0x64]);
    b.addByte(0x06);
    writeVarint(b, seq + 1);
    b.addByte(0x01);
    _writeLenString(b, channel);
    b.addByte(0x01);
    _writeLenString(b, method);
    if (params == null) {
      b.add(const [0x04, 0x00]);
    } else if (params is Map) {
      b.add(const [0x04, 0x01, 0x05]);
      _writeLenString(b, jsonEncode(params));
    } else if (params is String) {
      b.add(const [0x04, 0x01, 0x01]);
      _writeLenString(b, params);
    } else {
      throw ArgumentError('params 仅支持 null/Map/String: $params');
    }
    final bytes = b.toBytes();
    return jsonEncode({
      'type': 'data',
      'payload': {
        'zcode_type': 'rpc-frame',
        'bridgeSessionId': bridgeSessionId,
        'bridgeGeneration': bridgeGeneration,
        'seq': seq,
        'messageSeq': seq,
        'fragmentIndex': 0,
        'fragmentCount': 1,
        'messageBytes': bytes.length,
        'checksum': {'algorithm': 'crc32', 'value': crc32Hex(bytes)},
        'dataBase64': base64Encode(bytes),
      },
    });
  }

  static ({int id, List<Object?> values}) parseRpcResponseBytes(
    Uint8List bytes,
  ) {
    if (bytes.length <= 6 ||
        bytes[0] != 4 ||
        bytes[1] != 2 ||
        bytes[4] != 1 ||
        bytes[5] != 6) {
      throw const FormatException('非 04 02 rpc 响应头');
    }
    final (id, offset) = readVarint(bytes, 6);
    final values = <Object?>[];
    var i = offset;
    while (i < bytes.length) {
      final tag = bytes[i++];
      if (tag == 0x00) break;
      if (tag == 0x04) {
        if (i >= bytes.length) break;
        final count = bytes[i++];
        if (count == 0) break;
        continue;
      }
      if (tag == 0x05) {
        final (len, next) = readVarint(bytes, i);
        if (next + len > bytes.length) break;
        final text = utf8.decode(bytes.sublist(next, next + len));
        try {
          values.add(jsonDecode(text));
        } catch (_) {
          break;
        }
        i = next + len;
        continue;
      }
      if (tag == 0x01) {
        final (len, next) = readVarint(bytes, i);
        if (next + len > bytes.length) break;
        values.add(utf8.decode(bytes.sublist(next, next + len)));
        i = next + len;
        continue;
      }
      if (tag == 0x06) {
        final (value, next) = readVarint(bytes, i);
        values.add(value);
        i = next;
        continue;
      }
      break;
    }
    return (id: id, values: values);
  }

  static List<Object?> parseConcatenatedJsonText(String text) {
    final out = <Object?>[];
    var start = text.indexOf('{');
    while (start >= 0 && start < text.length) {
      var depth = 0;
      var inString = false;
      var end = -1;
      for (var j = start; j < text.length; j++) {
        final c = text[j];
        if (inString) {
          if (c == r'\') {
            j++;
          } else if (c == '"') {
            inString = false;
          }
          continue;
        }
        if (c == '"') {
          inString = true;
        } else if (c == '{') {
          depth++;
        } else if (c == '}') {
          depth--;
          if (depth == 0) {
            end = j;
            break;
          }
        }
      }
      if (end < 0) break;
      try {
        out.add(jsonDecode(text.substring(start, end + 1)));
      } catch (_) {
        break;
      }
      start = text.indexOf('{', end + 1);
    }
    return out;
  }
}
