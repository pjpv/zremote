import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'url_credential_persistence.g.dart';

@ExchangeableEnum()
class URLCredentialPersistence_ {
  // ignore: unused_field
  final int _value;
  const URLCredentialPersistence_._internal(this._value);

  static const NONE = const URLCredentialPersistence_._internal(0);

  static const FOR_SESSION = const URLCredentialPersistence_._internal(1);

  static const PERMANENT = const URLCredentialPersistence_._internal(2);

  static const SYNCHRONIZABLE = const URLCredentialPersistence_._internal(3);
}

@Deprecated("Use URLCredentialPersistence instead")
@ExchangeableEnum()
class IOSURLCredentialPersistence_ {
  // ignore: unused_field
  final int _value;
  const IOSURLCredentialPersistence_._internal(this._value);

  static const NONE = const IOSURLCredentialPersistence_._internal(0);

  static const FOR_SESSION = const IOSURLCredentialPersistence_._internal(1);

  static const PERMANENT = const IOSURLCredentialPersistence_._internal(2);

  static const SYNCHRONIZABLE = const IOSURLCredentialPersistence_._internal(3);
}
