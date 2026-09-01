# ZRemote

[中文](README.md) | **English**

A mobile companion app for ZCode desktop remote control. The desktop shows a QR code; scan it once with your phone to import the device and it stays usable long-term. Manage multiple machines in parallel and switch between them in a single UI.

<p align="center">
  <img src="docs/screenshot.jpg" width="270" alt="ZRemote App interface" />
  <img src="docs/screenshot-2.jpg" width="270" alt="ZRemote App interface" />
  <img src="docs/session-panel-en.png" width="270" alt="Session overview panel" />
</p>

## Features

- **Import via QR / paste** — scan the remote-control QR code shown by the desktop, or paste the control link, to add a device
- **Parallel multi-device sessions** — every device stays online at once; switching never reconnects
- **Session overview panel** — cross-project task cards at a glance: project · relative time · status capsule, grouped by today / yesterday / earlier; a live dot tracks the session currently being viewed, tap to jump straight to it
- **Task event notifications** — approval requests, task completions and failures arrive as system notifications; each type has its own toggle (approval only by default), with unread badges so nothing slips by in the background or on the lock screen; notifications retract automatically once the desktop side resolves the pending item
- **Background keep-alive** — a foreground guard service keeps sessions alive in background and with the screen off; battery-optimization whitelist guidance included, auto-recovers on return to foreground
- **Session health indicator** — per-device connection state at a glance (loading / connected / error)
- **One-tap refresh & auto recovery** — reload a broken session manually; repeated failures fall back to automatic reload
- **Biometric gate** — lock the app with fingerprint / Face ID; verification required both to enable and to disable; lock screen carries the brand visual
- **Chinese / English** — switch languages in-app, or follow the system language
- **Settings page** — General (language), Security, Background and Notification preferences in one place; the device list stays purely operational
- **Dark console UI** — a dark interface friendly to low-light environments

## Download & Install

Get the latest build from the [Releases](https://github.com/pjpv/zremote/releases) page:

- **Android** — `app-release.apk`, install directly after downloading
- **iOS** — `zremote-ios-unsigned.ipa`, an **unsigned build that cannot be installed directly**: sideload it with your own Apple ID via [AltStore](https://altstore.io), [Sideloadly](https://sideloadly.io), TrollStore, or similar (free-account signatures last 7 days and must be renewed)

## Building

Requirements:

- Flutter ≥ 3.38 (Dart ≥ 3.10)
- JDK 17 (Android builds)
- Xcode (iOS builds, macOS only)

```bash
flutter pub get

# Android
flutter build apk --release

# iOS (unsigned)
flutter build ios --release --no-codesign
```

## Usage

1. Open remote control in ZCode on the desktop and show the QR code
2. Scan it with the app (or paste the link)
3. Tap a device card to open its control session; the top-bar title switches devices anytime
4. When a task awaits approval or completes, a system notification arrives instantly; preferences live in the Settings page

## Disclaimer

ZRemote is a community-driven open-source project and is not an official tool; it is not affiliated with Z.ai. ZCode and related names and trademarks belong to their respective owners.

## License

[MIT](LICENSE)
