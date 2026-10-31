import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

part 'permission_resource_type.g.dart';

@ExchangeableEnum()
class PermissionResourceType_ {
  // ignore: unused_field
  final String _value;
  // ignore: unused_field
  final dynamic _nativeValue = null;
  const PermissionResourceType_._internal(this._value);

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'PermissionRequest.RESOURCE_AUDIO_CAPTURE',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/PermissionRequest#RESOURCE_AUDIO_CAPTURE',
        value: 'android.webkit.resource.AUDIO_CAPTURE'),
    EnumIOSPlatform(
        available: "15.0",
        apiName: 'WKMediaCaptureType.microphone',
        apiUrl:
            'https://developer.apple.com/documentation/webkit/wkmediacapturetype/microphone',
        value: 1),
    EnumMacOSPlatform(
        available: "12.0",
        apiName: 'WKMediaCaptureType.microphone',
        apiUrl:
            'https://developer.apple.com/documentation/webkit/wkmediacapturetype/microphone',
        value: 1),
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_PERMISSION_KIND_MICROPHONE',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2792.45#corewebview2_permission_kind',
        value: 1)
  ])
  static const MICROPHONE = PermissionResourceType_._internal('MICROPHONE');

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'PermissionRequest.RESOURCE_MIDI_SYSEX',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/PermissionRequest#RESOURCE_MIDI_SYSEX',
        value: 'android.webkit.resource.MIDI_SYSEX'),
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_PERMISSION_KIND_MIDI_SYSTEM_EXCLUSIVE_MESSAGES',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2792.45#corewebview2_permission_kind',
        value: 11)
  ])
  static const MIDI_SYSEX = PermissionResourceType_._internal('MIDI_SYSEX');

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'PermissionRequest.RESOURCE_PROTECTED_MEDIA_ID',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/PermissionRequest#RESOURCE_PROTECTED_MEDIA_ID',
        value: 'android.webkit.resource.PROTECTED_MEDIA_ID'),
  ])
  static const PROTECTED_MEDIA_ID =
      PermissionResourceType_._internal('PROTECTED_MEDIA_ID');

  @EnumSupportedPlatforms(platforms: [
    EnumAndroidPlatform(
        apiName: 'PermissionRequest.RESOURCE_VIDEO_CAPTURE',
        apiUrl:
            'https://developer.android.com/reference/android/webkit/PermissionRequest#RESOURCE_VIDEO_CAPTURE',
        value: 'android.webkit.resource.VIDEO_CAPTURE'),
    EnumIOSPlatform(
        available: "15.0",
        apiName: 'WKMediaCaptureType.camera',
        apiUrl:
            'https://developer.apple.com/documentation/webkit/wkmediacapturetype/camera',
        value: 0),
    EnumMacOSPlatform(
        available: "12.0",
        apiName: 'WKMediaCaptureType.camera',
        apiUrl:
            'https://developer.apple.com/documentation/webkit/wkmediacapturetype/camera',
        value: 0),
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_PERMISSION_KIND_CAMERA',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2792.45#corewebview2_permission_kind',
        value: 2)
  ])
  static const CAMERA = PermissionResourceType_._internal('CAMERA');

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(
        available: "15.0",
        apiName: 'WKMediaCaptureType.cameraAndMicrophone',
        apiUrl:
            'https://developer.apple.com/documentation/webkit/wkmediacapturetype/cameraandmicrophone',
        value: 2),
    EnumMacOSPlatform(
        available: "12.0",
        apiName: 'WKMediaCaptureType.cameraAndMicrophone',
        apiUrl:
            'https://developer.apple.com/documentation/webkit/wkmediacapturetype/cameraandmicrophone',
        value: 2)
  ])
  static const CAMERA_AND_MICROPHONE =
      PermissionResourceType_._internal('CAMERA_AND_MICROPHONE');

  @EnumSupportedPlatforms(platforms: [
    EnumIOSPlatform(available: "15.0", value: 'deviceOrientationAndMotion'),
    EnumMacOSPlatform(available: "12.0", value: 'deviceOrientationAndMotion')
  ])
  static const DEVICE_ORIENTATION_AND_MOTION =
      PermissionResourceType_._internal('DEVICE_ORIENTATION_AND_MOTION');

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_PERMISSION_KIND_UNKNOWN_PERMISSION',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2792.45#corewebview2_permission_kind',
        value: 0)
  ])
  static const UNKNOWN = PermissionResourceType_._internal('UNKNOWN');

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_PERMISSION_KIND_GEOLOCATION',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2792.45#corewebview2_permission_kind',
        value: 3)
  ])
  static const GEOLOCATION = PermissionResourceType_._internal('GEOLOCATION');

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_PERMISSION_KIND_NOTIFICATIONS',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2792.45#corewebview2_permission_kind',
        value: 4)
  ])
  static const NOTIFICATIONS =
      PermissionResourceType_._internal('NOTIFICATIONS');

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_PERMISSION_KIND_OTHER_SENSORS',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2792.45#corewebview2_permission_kind',
        value: 5)
  ])
  static const OTHER_SENSORS =
      PermissionResourceType_._internal('OTHER_SENSORS');

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_PERMISSION_KIND_CLIPBOARD_READ',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2792.45#corewebview2_permission_kind',
        value: 6)
  ])
  static const CLIPBOARD_READ =
      PermissionResourceType_._internal('CLIPBOARD_READ');

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_PERMISSION_KIND_MULTIPLE_AUTOMATIC_DOWNLOADS',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2792.45#corewebview2_permission_kind',
        value: 7)
  ])
  static const MULTIPLE_AUTOMATIC_DOWNLOADS =
      PermissionResourceType_._internal('MULTIPLE_AUTOMATIC_DOWNLOADS');

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_PERMISSION_KIND_FILE_READ_WRITE',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2792.45#corewebview2_permission_kind',
        value: 8)
  ])
  static const FILE_READ_WRITE =
      PermissionResourceType_._internal('FILE_READ_WRITE');

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_PERMISSION_KIND_AUTOPLAY',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2792.45#corewebview2_permission_kind',
        value: 9)
  ])
  static const AUTOPLAY = PermissionResourceType_._internal('AUTOPLAY');

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_PERMISSION_KIND_LOCAL_FONTS',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2792.45#corewebview2_permission_kind',
        value: 10)
  ])
  static const LOCAL_FONTS = PermissionResourceType_._internal('LOCAL_FONTS');

  @EnumSupportedPlatforms(platforms: [
    EnumWindowsPlatform(
        apiName: 'COREWEBVIEW2_PERMISSION_KIND_WINDOW_MANAGEMENT',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2792.45#corewebview2_permission_kind',
        value: 12)
  ])
  static const WINDOW_MANAGEMENT =
      PermissionResourceType_._internal('WINDOW_MANAGEMENT');
}
