import 'dart:convert';
import 'dart:typed_data';

import 'asn1_identifier.dart';
import 'asn1_object.dart';

class ASN1DERDecoder {
  static List<ASN1Object> decode({required List<int> data}) {
    var iterator = data.iterator;
    return parse(iterator: iterator);
  }

  static List<ASN1Object> parse({required Iterator<int> iterator}) {
    var result = <ASN1Object>[];

    while (iterator.moveNext()) {
      var nextValue = iterator.current;

      var asn1obj = ASN1Object();
      asn1obj.identifier = ASN1Identifier(nextValue);

      if (asn1obj.identifier!.isConstructed()) {
        var contentData = loadSubContent(iterator: iterator);

        if (contentData.isEmpty) {
          asn1obj.sub = parse(iterator: iterator);
        } else {
          var subIterator = contentData.iterator;
          asn1obj.sub = parse(iterator: subIterator);
        }

        asn1obj.value = null;

        asn1obj.encoded = Uint8List.fromList(contentData);

        if (asn1obj.sub != null) {
          for (var item in asn1obj.sub!) {
            item.parent = asn1obj;
          }
        }
      } else {
        if (asn1obj.identifier!.typeClass() == ASN1IdentifierClass.UNIVERSAL) {
          var contentData = loadSubContent(iterator: iterator);

          asn1obj.encoded = Uint8List.fromList(contentData);

          var tagNumber = asn1obj.identifier!.tagNumber();

          if (tagNumber == ASN1IdentifierTagNumber.END_OF_CONTENT) {
            return result;
          } else if (tagNumber == ASN1IdentifierTagNumber.BOOLEAN) {
            var value = contentData.length > 0 ? contentData.first : null;
            if (value != null) {
              asn1obj.value = value > 0 ? true : false;
            }
          } else if (tagNumber == ASN1IdentifierTagNumber.INTEGER) {
            while (contentData.length > 0 && contentData.first == 0) {
              contentData.removeAt(0);
            }
            asn1obj.value = contentData;
          } else if (tagNumber == ASN1IdentifierTagNumber.NULL) {
            asn1obj.value = null;
          } else if (tagNumber == ASN1IdentifierTagNumber.OBJECT_IDENTIFIER) {
            asn1obj.value = decodeOid(contentData: contentData);
          } else if ([
            ASN1IdentifierTagNumber.UTF8_STRING,
            ASN1IdentifierTagNumber.PRINTABLE_STRING,
            ASN1IdentifierTagNumber.NUMERIC_STRING,
            ASN1IdentifierTagNumber.GENERAL_STRING,
            ASN1IdentifierTagNumber.UNIVERSAL_STRING,
            ASN1IdentifierTagNumber.CHARACTER_STRING,
            ASN1IdentifierTagNumber.T61_STRING
          ].contains(tagNumber)) {
            asn1obj.value = utf8.decode(contentData, allowMalformed: true);
          } else if (tagNumber == ASN1IdentifierTagNumber.BMP_STRING) {
            asn1obj.value = String.fromCharCodes(contentData);
          } else if ([
            ASN1IdentifierTagNumber.VISIBLE_STRING,
            ASN1IdentifierTagNumber.IA5_STRING
          ].contains(tagNumber)) {
            asn1obj.value = ascii.decode(contentData, allowInvalid: true);
          } else if (tagNumber == ASN1IdentifierTagNumber.UTC_TIME) {
            asn1obj.value = utcTimeToDate(contentData: contentData);
          } else if (tagNumber == ASN1IdentifierTagNumber.GENERALIZED_TIME) {
            asn1obj.value = generalizedTimeToDate(contentData: contentData);
          } else if (tagNumber == ASN1IdentifierTagNumber.BIT_STRING) {
            if (contentData.length > 0) {
              contentData.removeAt(0);
            }
            asn1obj.value = contentData;
          } else if (tagNumber == ASN1IdentifierTagNumber.OCTET_STRING) {
            try {
              var subIterator = contentData.iterator;
              asn1obj.sub = parse(iterator: subIterator);
            } catch (e) {
              var str;
              try {
                str = utf8.decode(contentData);
              } catch (e) {}
              if (str != null) {
                asn1obj.value = str;
              } else {
                asn1obj.value = contentData;
              }
            }
          } else {
            asn1obj.value = contentData;
          }
        } else {

          var contentData = loadSubContent(iterator: iterator);

          var str;
          try {
            str = utf8.decode(contentData);
          } catch (e) {}
          if (str != null) {
            asn1obj.value = str;
          } else {
            asn1obj.value = contentData;
          }
        }
      }
      result.add(asn1obj);
    }

    return result;
  }

  static BigInt getContentLength({required Iterator<int> iterator}) {
    if (iterator.moveNext()) {
      int? first;
      try {
        first = iterator.current;
      } catch (e) {}
      if (first != null) {
        if ((first & 0x80) != 0) {

          var octetsToRead = first - 0x80;
          var data = <int>[];
          for (var i = 0; i < octetsToRead; i++) {
            if (iterator.moveNext()) {
              int? n;
              try {
                n = iterator.current;
              } catch (e) {}
              if (n != null) {
                data.add(n);
              }
            }
          }

          return toIntValue(data) ?? BigInt.from(0);
        } else {
          return BigInt.from(first);
        }
      }
    }
    return BigInt.from(0);
  }

  static List<int> loadSubContent({required Iterator<int> iterator}) {
    var len = getContentLength(iterator: iterator);
    int int64MaxValue = double.maxFinite.toInt();

    if (len >= BigInt.from(int64MaxValue)) {
      return <int>[];
    }

    var byteArray = <int>[];

    for (var i = 0; i < len.toInt(); i++) {
      if (iterator.moveNext()) {
        int? n;
        try {
          n = iterator.current;
        } catch (e) {}
        if (n != null) {
          byteArray.add(n);
        }
      } else {
        throw ASN1OutOfBufferError();
      }
    }

    return byteArray;
  }

  static String? decodeOid({required List<int> contentData}) {
    if (contentData.isEmpty) {
      return null;
    }

    var oid = "";

    var first = contentData.removeAt(0);
    oid += "${(first / 40).truncate()}.${first % 40}";

    var t = 0;
    while (contentData.length > 0) {
      var n = contentData.removeAt(0);
      t = (t << 7) | (n & 0x7F);
      if ((n & 0x80) == 0) {
        oid += ".$t";
        t = 0;
      }
    }
    return oid;
  }

  static DateTime? utcTimeToDate({required List<int> contentData}) {

    String? utc;
    try {
      utc = utf8.decode(contentData);
    } catch (e) {}
    if (utc == null) {
      return null;
    }

    var year = int.parse(utc.substring(0, 2), radix: 10);
    year = (year >= 50) ? 1900 + year : 2000 + year;
    // ignore: non_constant_identifier_names
    var MM = int.parse(utc.substring(2, 4), radix: 10);
    // ignore: non_constant_identifier_names
    var DD = int.parse(utc.substring(4, 6), radix: 10);
    var hh = int.parse(utc.substring(6, 8), radix: 10);
    var mm = int.parse(utc.substring(8, 10), radix: 10);
    var ss = 0;

    int? end;
    String? c;
    if (utc.length > 11) {
      c = utc[10];
      end = 10;

      if (c != '+' && c != '-') {
        ss = int.parse(utc.substring(10, 12), radix: 10);
        end += 2;
      }
    }

    var date = DateTime.utc(year, MM, DD, hh, mm, ss, 0);

    if (end != null) {
      c = utc[end];
      if (c == '+' || c == '-') {
        var hhoffset =
            int.parse(utc.substring(end + 1, end + 1 + 2), radix: 10);
        var mmoffset =
            int.parse(utc.substring(end + 4, end + 4 + 2), radix: 10);

        var offset = hhoffset * 60 + mmoffset;
        offset *= 60000;

        var offsetDuration = Duration(milliseconds: offset);
        if (c == '+') {
          date.subtract(offsetDuration);
        } else {
          date.add(offsetDuration);
        }
      }
    }

    return date;
  }

  static DateTime? generalizedTimeToDate({required List<int> contentData}) {

    String? gentime;
    try {
      gentime = utf8.decode(contentData);
    } catch (e) {}
    if (gentime == null) {
      return null;
    }

    // ignore: non_constant_identifier_names
    var YYYY = int.parse(gentime.substring(0, 4), radix: 10);
    // ignore: non_constant_identifier_names
    var MM = int.parse(gentime.substring(4, 6), radix: 10);
    // ignore: non_constant_identifier_names
    var DD = int.parse(gentime.substring(6, 8), radix: 10);
    var hh = int.parse(gentime.substring(8, 10), radix: 10);
    var mm = int.parse(gentime.substring(10, 12), radix: 10);
    var ss = int.parse(gentime.substring(12, 14), radix: 10);

    double fff = 0.0;
    var offset = 0;
    var isUTC = false;

    if (gentime[gentime.length - 1] == 'Z') {
      isUTC = true;
    }

    var end = gentime.length - 5;
    var c = gentime[end];
    if (c == '+' || c == '-') {
      var hhoffset =
          int.parse(gentime.substring(end + 1, end + 1 + 2), radix: 10);
      var mmoffset =
          int.parse(gentime.substring(end + 4, end + 4 + 2), radix: 10);

      offset = hhoffset * 60 + mmoffset;
      offset *= 60000;

      if (c == '+') {
        offset *= -1;
      }

      isUTC = true;
    }

    if (gentime[14] == '.') {
      fff = double.parse(gentime.substring(14)) * 1000;
    }

    var date = DateTime.utc(YYYY, MM, DD, hh, mm, ss, fff.toInt());

    if (isUTC) {
      var offsetDuration = Duration(milliseconds: offset);
      date.add(offsetDuration);
    }

    return date;
  }

  static List<int> sequenceContent({required List<int> data}) {
    var iterator = data.iterator;
    iterator.moveNext();
    try {
      return loadSubContent(iterator: iterator);
    } catch (e) {
      return data;
    }
  }
}

BigInt? toIntValue(List<int> data) {
  if (data.length > 8) {
    return null;
  }

  BigInt value = BigInt.from(0);
  for (var index = 0; index < data.length; index++) {
    var byte = data[index];
    value += BigInt.from(byte << 8 * (data.length - index - 1));
  }
  return value;
}

class ASN1OutOfBufferError extends Error {}

class ASN1ParseError extends Error {}
