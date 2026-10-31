
part of 'content_blocker_action_type.dart';

class ContentBlockerActionType {
  final String _value;
  final String _nativeValue;
  const ContentBlockerActionType._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory ContentBlockerActionType._internalMultiPlatform(
          String value, Function nativeValue) =>
      ContentBlockerActionType._internal(value, nativeValue());

  static final BLOCK =
      ContentBlockerActionType._internalMultiPlatform('block', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'block';
      case TargetPlatform.iOS:
        return 'block';
      case TargetPlatform.macOS:
        return 'block';
      default:
        break;
    }
    return null;
  });

  static final BLOCK_COOKIES =
      ContentBlockerActionType._internalMultiPlatform('block-cookies', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'block-cookies';
      case TargetPlatform.macOS:
        return 'block-cookies';
      default:
        break;
    }
    return null;
  });

  static final CSS_DISPLAY_NONE =
      ContentBlockerActionType._internalMultiPlatform('css-display-none', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'css-display-none';
      case TargetPlatform.iOS:
        return 'css-display-none';
      case TargetPlatform.macOS:
        return 'css-display-none';
      default:
        break;
    }
    return null;
  });

  static final IGNORE_PREVIOUS_RULES =
      ContentBlockerActionType._internalMultiPlatform('ignore-previous-rules',
          () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ignore-previous-rules';
      case TargetPlatform.macOS:
        return 'ignore-previous-rules';
      default:
        break;
    }
    return null;
  });

  static final MAKE_HTTPS =
      ContentBlockerActionType._internalMultiPlatform('make-https', () {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'make-https';
      case TargetPlatform.iOS:
        return 'make-https';
      case TargetPlatform.macOS:
        return 'make-https';
      default:
        break;
    }
    return null;
  });

  static final Set<ContentBlockerActionType> values = [
    ContentBlockerActionType.BLOCK,
    ContentBlockerActionType.BLOCK_COOKIES,
    ContentBlockerActionType.CSS_DISPLAY_NONE,
    ContentBlockerActionType.IGNORE_PREVIOUS_RULES,
    ContentBlockerActionType.MAKE_HTTPS,
  ].toSet();

  static ContentBlockerActionType? fromValue(String? value) {
    if (value != null) {
      try {
        return ContentBlockerActionType.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static ContentBlockerActionType? fromNativeValue(String? value) {
    if (value != null) {
      try {
        return ContentBlockerActionType.values
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
