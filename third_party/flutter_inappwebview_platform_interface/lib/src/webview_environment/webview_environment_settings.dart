import 'package:flutter_inappwebview_internal_annotations/flutter_inappwebview_internal_annotations.dart';

import 'platform_webview_environment.dart';
import '../types/custom_scheme_registration.dart';

part 'webview_environment_settings.g.dart';

@SupportedPlatforms(platforms: [WindowsPlatform()])
@ExchangeableObject(copyMethod: true)
class WebViewEnvironmentSettings_ {
  @SupportedPlatforms(platforms: [
    WindowsPlatform(
        apiName:
            'CreateCoreWebView2EnvironmentWithOptions.browserExecutableFolder',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#createcorewebview2environmentwithoptions')
  ])
  final String? browserExecutableFolder;

  @SupportedPlatforms(platforms: [
    WindowsPlatform(
        apiName: 'CreateCoreWebView2EnvironmentWithOptions.userDataFolder',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/webview2-idl?view=webview2-1.0.2210.55#createcorewebview2environmentwithoptions')
  ])
  final String? userDataFolder;

  @SupportedPlatforms(platforms: [
    WindowsPlatform(
        apiName:
            'ICoreWebView2EnvironmentOptions.put_AdditionalBrowserArguments',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2environmentoptions?view=webview2-1.0.2210.55#put_additionalbrowserarguments')
  ])
  final String? additionalBrowserArguments;

  @SupportedPlatforms(platforms: [
    WindowsPlatform(
        apiName:
            'ICoreWebView2EnvironmentOptions.put_AllowSingleSignOnUsingOSPrimaryAccount',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2environmentoptions?view=webview2-1.0.2210.55#put_allowsinglesignonusingosprimaryaccount')
  ])
  final bool? allowSingleSignOnUsingOSPrimaryAccount;

  @SupportedPlatforms(platforms: [
    WindowsPlatform(
        apiName: 'ICoreWebView2EnvironmentOptions.put_Language',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2environmentoptions?view=webview2-1.0.2210.55#put_language')
  ])
  final String? language;

  @SupportedPlatforms(platforms: [
    WindowsPlatform(
        apiName:
            'ICoreWebView2EnvironmentOptions.put_TargetCompatibleBrowserVersion',
        apiUrl:
            'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2environmentoptions?view=webview2-1.0.2210.55#put_targetcompatiblebrowserversion')
  ])
  final String? targetCompatibleBrowserVersion;

  @SupportedPlatforms(platforms: [
    WindowsPlatform(
        apiName:
        'ICoreWebView2EnvironmentOptions4.SetCustomSchemeRegistrations',
        apiUrl:
        'https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/win32/icorewebview2environmentoptions4?view=webview2-1.0.2739.15#setcustomschemeregistrations')
  ])
  final List<CustomSchemeRegistration_>? customSchemeRegistrations;

  WebViewEnvironmentSettings_(
      {this.browserExecutableFolder,
      this.userDataFolder,
      this.additionalBrowserArguments,
      this.allowSingleSignOnUsingOSPrimaryAccount,
      this.language,
      this.targetCompatibleBrowserVersion,
      this.customSchemeRegistrations});
}
