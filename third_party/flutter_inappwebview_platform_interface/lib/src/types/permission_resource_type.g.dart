
part of 'permission_resource_type.dart';

class PermissionResourceType {
  final String _value;
  final dynamic _nativeValue;
  const PermissionResourceType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory PermissionResourceType._internalMultiPlatform(
          String value, Function nativeValue) =>
      PermissionResourceType._internal(value, nativeValue());

  static final AUTOPLAY =
      PermissionResourceType._internalMultiPlatform('AUTOPLAY', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return 9;
      default:
        break;
    }
    return null;
  });

  static final CAMERA =
      PermissionResourceType._internalMultiPlatform('CAMERA', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android.webkit.resource.VIDEO_CAPTURE';
      case TargetPlatform.iOS:
        return 0;
      case TargetPlatform.macOS:
        return 0;
      case TargetPlatform.windows:
        return 2;
      default:
        break;
    }
    return null;
  });

  static final CAMERA_AND_MICROPHONE =
      PermissionResourceType._internalMultiPlatform('CAMERA_AND_MICROPHONE',
          () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 2;
      case TargetPlatform.macOS:
        return 2;
      default:
        break;
    }
    return null;
  });

  static final CLIPBOARD_READ =
      PermissionResourceType._internalMultiPlatform('CLIPBOARD_READ', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return 6;
      default:
        break;
    }
    return null;
  });

  static final DEVICE_ORIENTATION_AND_MOTION =
      PermissionResourceType._internalMultiPlatform(
          'DEVICE_ORIENTATION_AND_MOTION', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'deviceOrientationAndMotion';
      case TargetPlatform.macOS:
        return 'deviceOrientationAndMotion';
      default:
        break;
    }
    return null;
  });

  static final FILE_READ_WRITE =
      PermissionResourceType._internalMultiPlatform('FILE_READ_WRITE', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return 8;
      default:
        break;
    }
    return null;
  });

  static final GEOLOCATION =
      PermissionResourceType._internalMultiPlatform('GEOLOCATION', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return 3;
      default:
        break;
    }
    return null;
  });

  static final LOCAL_FONTS =
      PermissionResourceType._internalMultiPlatform('LOCAL_FONTS', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return 10;
      default:
        break;
    }
    return null;
  });

  static final MICROPHONE =
      PermissionResourceType._internalMultiPlatform('MICROPHONE', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android.webkit.resource.AUDIO_CAPTURE';
      case TargetPlatform.iOS:
        return 1;
      case TargetPlatform.macOS:
        return 1;
      case TargetPlatform.windows:
        return 1;
      default:
        break;
    }
    return null;
  });

  static final MIDI_SYSEX =
      PermissionResourceType._internalMultiPlatform('MIDI_SYSEX', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android.webkit.resource.MIDI_SYSEX';
      case TargetPlatform.windows:
        return 11;
      default:
        break;
    }
    return null;
  });

  static final MULTIPLE_AUTOMATIC_DOWNLOADS =
      PermissionResourceType._internalMultiPlatform(
          'MULTIPLE_AUTOMATIC_DOWNLOADS', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return 7;
      default:
        break;
    }
    return null;
  });

  static final NOTIFICATIONS =
      PermissionResourceType._internalMultiPlatform('NOTIFICATIONS', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return 4;
      default:
        break;
    }
    return null;
  });

  static final OTHER_SENSORS =
      PermissionResourceType._internalMultiPlatform('OTHER_SENSORS', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return 5;
      default:
        break;
    }
    return null;
  });

  static final PROTECTED_MEDIA_ID =
      PermissionResourceType._internalMultiPlatform('PROTECTED_MEDIA_ID', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android.webkit.resource.PROTECTED_MEDIA_ID';
      default:
        break;
    }
    return null;
  });

  static final UNKNOWN =
      PermissionResourceType._internalMultiPlatform('UNKNOWN', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return 0;
      default:
        break;
    }
    return null;
  });

  static final WINDOW_MANAGEMENT =
      PermissionResourceType._internalMultiPlatform('WINDOW_MANAGEMENT', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return 12;
      default:
        break;
    }
    return null;
  });

  static final Set<PermissionResourceType> values = [
    PermissionResourceType.AUTOPLAY,
    PermissionResourceType.CAMERA,
    PermissionResourceType.CAMERA_AND_MICROPHONE,
    PermissionResourceType.CLIPBOARD_READ,
    PermissionResourceType.DEVICE_ORIENTATION_AND_MOTION,
    PermissionResourceType.FILE_READ_WRITE,
    PermissionResourceType.GEOLOCATION,
    PermissionResourceType.LOCAL_FONTS,
    PermissionResourceType.MICROPHONE,
    PermissionResourceType.MIDI_SYSEX,
    PermissionResourceType.MULTIPLE_AUTOMATIC_DOWNLOADS,
    PermissionResourceType.NOTIFICATIONS,
    PermissionResourceType.OTHER_SENSORS,
    PermissionResourceType.PROTECTED_MEDIA_ID,
    PermissionResourceType.UNKNOWN,
    PermissionResourceType.WINDOW_MANAGEMENT,
  ].toSet();

  static PermissionResourceType? fromValue(String? value) {
    if (value != null) {
      try {
        return PermissionResourceType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static PermissionResourceType? fromNativeValue(dynamic value) {
    if (value != null) {
      try {
        return PermissionResourceType.values
            .firstWhere((element) => element.toNativeValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String toValue() => _value;

  dynamic toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() {
    return _value;
  }
}
