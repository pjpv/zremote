
part of 'data_detector_types.dart';

class DataDetectorTypes {
  final String _value;
  final String _nativeValue;
  const DataDetectorTypes._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory DataDetectorTypes._internalMultiPlatform(
          String value, Function nativeValue) =>
      DataDetectorTypes._internal(value, nativeValue());

  static const ADDRESS = DataDetectorTypes._internal('ADDRESS', 'ADDRESS');

  static const ALL = DataDetectorTypes._internal('ALL', 'ALL');

  static const CALENDAR_EVENT =
      DataDetectorTypes._internal('CALENDAR_EVENT', 'CALENDAR_EVENT');

  static const FLIGHT_NUMBER =
      DataDetectorTypes._internal('FLIGHT_NUMBER', 'FLIGHT_NUMBER');

  static const LINK = DataDetectorTypes._internal('LINK', 'LINK');

  static const LOOKUP_SUGGESTION =
      DataDetectorTypes._internal('LOOKUP_SUGGESTION', 'LOOKUP_SUGGESTION');

  static const NONE = DataDetectorTypes._internal('NONE', 'NONE');

  static const PHONE_NUMBER =
      DataDetectorTypes._internal('PHONE_NUMBER', 'PHONE_NUMBER');

  static const SPOTLIGHT_SUGGESTION = DataDetectorTypes._internal(
      'SPOTLIGHT_SUGGESTION', 'SPOTLIGHT_SUGGESTION');

  static const TRACKING_NUMBER =
      DataDetectorTypes._internal('TRACKING_NUMBER', 'TRACKING_NUMBER');

  static final Set<DataDetectorTypes> values = [
    DataDetectorTypes.ADDRESS,
    DataDetectorTypes.ALL,
    DataDetectorTypes.CALENDAR_EVENT,
    DataDetectorTypes.FLIGHT_NUMBER,
    DataDetectorTypes.LINK,
    DataDetectorTypes.LOOKUP_SUGGESTION,
    DataDetectorTypes.NONE,
    DataDetectorTypes.PHONE_NUMBER,
    DataDetectorTypes.SPOTLIGHT_SUGGESTION,
    DataDetectorTypes.TRACKING_NUMBER,
  ].toSet();

  static DataDetectorTypes? fromValue(String? value) {
    if (value != null) {
      try {
        return DataDetectorTypes.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static DataDetectorTypes? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return DataDetectorTypes.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String toValue() => _value;

  String toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}

@Deprecated('Use DataDetectorTypes instead')
class IOSWKDataDetectorTypes {
  final String _value;
  final String _nativeValue;
  const IOSWKDataDetectorTypes._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory IOSWKDataDetectorTypes._internalMultiPlatform(
          String value, Function nativeValue) =>
      IOSWKDataDetectorTypes._internal(value, nativeValue());

  static const ADDRESS = IOSWKDataDetectorTypes._internal('ADDRESS', 'ADDRESS');

  static const ALL = IOSWKDataDetectorTypes._internal('ALL', 'ALL');

  static const CALENDAR_EVENT =
      IOSWKDataDetectorTypes._internal('CALENDAR_EVENT', 'CALENDAR_EVENT');

  static const FLIGHT_NUMBER =
      IOSWKDataDetectorTypes._internal('FLIGHT_NUMBER', 'FLIGHT_NUMBER');

  static const LINK = IOSWKDataDetectorTypes._internal('LINK', 'LINK');

  static const LOOKUP_SUGGESTION = IOSWKDataDetectorTypes._internal(
      'LOOKUP_SUGGESTION', 'LOOKUP_SUGGESTION');

  static const NONE = IOSWKDataDetectorTypes._internal('NONE', 'NONE');

  static const PHONE_NUMBER =
      IOSWKDataDetectorTypes._internal('PHONE_NUMBER', 'PHONE_NUMBER');

  static const SPOTLIGHT_SUGGESTION = IOSWKDataDetectorTypes._internal(
      'SPOTLIGHT_SUGGESTION', 'SPOTLIGHT_SUGGESTION');

  static const TRACKING_NUMBER =
      IOSWKDataDetectorTypes._internal('TRACKING_NUMBER', 'TRACKING_NUMBER');

  static final Set<IOSWKDataDetectorTypes> values = [
    IOSWKDataDetectorTypes.ADDRESS,
    IOSWKDataDetectorTypes.ALL,
    IOSWKDataDetectorTypes.CALENDAR_EVENT,
    IOSWKDataDetectorTypes.FLIGHT_NUMBER,
    IOSWKDataDetectorTypes.LINK,
    IOSWKDataDetectorTypes.LOOKUP_SUGGESTION,
    IOSWKDataDetectorTypes.NONE,
    IOSWKDataDetectorTypes.PHONE_NUMBER,
    IOSWKDataDetectorTypes.SPOTLIGHT_SUGGESTION,
    IOSWKDataDetectorTypes.TRACKING_NUMBER,
  ].toSet();

  static IOSWKDataDetectorTypes? fromValue(String? value) {
    if (value != null) {
      try {
        return IOSWKDataDetectorTypes.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static IOSWKDataDetectorTypes? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return IOSWKDataDetectorTypes.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String toValue() => _value;

  String toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}
