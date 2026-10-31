import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'data_detector_types.g.dart';

@ExchangeableEnum()
class DataDetectorTypes_ {
  // ignore: unused_field
  final String _value;
  const DataDetectorTypes_._internal(this._value);

  static const NONE = const DataDetectorTypes_._internal("NONE");

  static const PHONE_NUMBER =
      const DataDetectorTypes_._internal("PHONE_NUMBER");

  static const LINK = const DataDetectorTypes_._internal("LINK");

  static const ADDRESS = const DataDetectorTypes_._internal("ADDRESS");

  static const CALENDAR_EVENT =
      const DataDetectorTypes_._internal("CALENDAR_EVENT");

  static const TRACKING_NUMBER =
      const DataDetectorTypes_._internal("TRACKING_NUMBER");

  static const FLIGHT_NUMBER =
      const DataDetectorTypes_._internal("FLIGHT_NUMBER");

  static const LOOKUP_SUGGESTION =
      const DataDetectorTypes_._internal("LOOKUP_SUGGESTION");

  static const SPOTLIGHT_SUGGESTION =
      const DataDetectorTypes_._internal("SPOTLIGHT_SUGGESTION");

  static const ALL = const DataDetectorTypes_._internal("ALL");
}

@Deprecated("Use DataDetectorTypes instead")
@ExchangeableEnum()
class IOSWKDataDetectorTypes_ {
  // ignore: unused_field
  final String _value;
  const IOSWKDataDetectorTypes_._internal(this._value);

  static const NONE = const IOSWKDataDetectorTypes_._internal("NONE");

  static const PHONE_NUMBER =
      const IOSWKDataDetectorTypes_._internal("PHONE_NUMBER");

  static const LINK = const IOSWKDataDetectorTypes_._internal("LINK");

  static const ADDRESS = const IOSWKDataDetectorTypes_._internal("ADDRESS");

  static const CALENDAR_EVENT =
      const IOSWKDataDetectorTypes_._internal("CALENDAR_EVENT");

  static const TRACKING_NUMBER =
      const IOSWKDataDetectorTypes_._internal("TRACKING_NUMBER");

  static const FLIGHT_NUMBER =
      const IOSWKDataDetectorTypes_._internal("FLIGHT_NUMBER");

  static const LOOKUP_SUGGESTION =
      const IOSWKDataDetectorTypes_._internal("LOOKUP_SUGGESTION");

  static const SPOTLIGHT_SUGGESTION =
      const IOSWKDataDetectorTypes_._internal("SPOTLIGHT_SUGGESTION");

  static const ALL = const IOSWKDataDetectorTypes_._internal("ALL");
}
