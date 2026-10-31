
part of 'form_resubmission_action.dart';

class FormResubmissionAction {
  final int _value;
  final int _nativeValue;
  const FormResubmissionAction._internal(this._value, this._nativeValue);
// ignore: unused_element
  factory FormResubmissionAction._internalMultiPlatform(
          int value, Function nativeValue) =>
      FormResubmissionAction._internal(value, nativeValue());

  static const DONT_RESEND = FormResubmissionAction._internal(1, 1);

  static const RESEND = FormResubmissionAction._internal(0, 0);

  static final Set<FormResubmissionAction> values = [
    FormResubmissionAction.DONT_RESEND,
    FormResubmissionAction.RESEND,
  ].toSet();

  static FormResubmissionAction? fromValue(int? value) {
    if (value != null) {
      try {
        return FormResubmissionAction.values
            .firstWhere((element) => element.toValue() == value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static FormResubmissionAction? fromNativeValue(int? value) {
    if (value != null) {
      try {
        return FormResubmissionAction.values
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
        return 'DONT_RESEND';
      case 0:
        return 'RESEND';
    }
    return _value.toString();
  }
}
