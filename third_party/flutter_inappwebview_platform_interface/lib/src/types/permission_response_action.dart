import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'permission_response.dart';

part 'permission_response_action.g.dart';

@ExchangeableEnum()
class PermissionResponseAction_ {
  // ignore: unused_field
  final int _value;
  const PermissionResponseAction_._internal(this._value);

  static const DENY = const PermissionResponseAction_._internal(0);

  static const GRANT = const PermissionResponseAction_._internal(1);

  static const PROMPT = const PermissionResponseAction_._internal(2);
}

@Deprecated("Use PermissionResponseAction instead")
@ExchangeableEnum()
class PermissionRequestResponseAction_ {
  // ignore: unused_field
  final int _value;
  const PermissionRequestResponseAction_._internal(this._value);

  static const DENY = const PermissionRequestResponseAction_._internal(0);

  static const GRANT = const PermissionRequestResponseAction_._internal(1);
}
