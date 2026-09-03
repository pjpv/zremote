import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/app_localizations.dart';
import 'models/device_label.dart';
import 'services/biometric.dart';
import 'services/device_store.dart';
import 'services/notifier.dart';
import 'state/keepalive.dart';
import 'state/locale.dart';
import 'state/session_pool.dart';
import 'theme.dart';
import 'state/app_lifecycle.dart';
import 'ui/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotifierService.instance.init();
  final store = DeviceStore.instance;
  final initialLocale = await store.localeSetting();
  final initialBiometric = await store.biometricEnabled();
  final initialKeepAlive = await store.keepAliveEnabled();
  runApp(
    ProviderScope(
      overrides: [
        localeSettingProvider.overrideWith(
          () => LocaleSettingNotifier(initial: initialLocale),
        ),
        biometricProvider.overrideWith(
          () => BiometricNotifier(initial: initialBiometric),
        ),
        keepAliveEnabledProvider.overrideWith(
          () => KeepAliveEnabledNotifier(initial: initialKeepAlive),
        ),
      ],
      child: const ZRemoteApp(),
    ),
  );
}

class ZRemoteApp extends ConsumerWidget {
  const ZRemoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(localeSettingProvider);
    return MaterialApp(
      title: 'ZRemote',
      debugShowCheckedModeBanner: false,
      theme: ZT.theme(),
      locale: setting == kLocaleSystem ? null : Locale(setting),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LifecycleWatcher(child: AppShell()),
      builder: (context, child) => BiometricGate(child: child!),
    );
  }
}

class BiometricGate extends ConsumerStatefulWidget {
  const BiometricGate({
    super.key,
    required this.child,
    this.relockAfter = const Duration(seconds: 10),
    this.authenticate = _defaultAuthenticate,
  });

  final Widget child;

  final Duration relockAfter;

  final Future<bool> Function(String reason) authenticate;

  static Future<bool> _defaultAuthenticate(String reason) =>
      BiometricService.instance.authenticate(reason);

  @override
  ConsumerState<BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends ConsumerState<BiometricGate>
    with WidgetsBindingObserver {
  bool _authed = false;
  bool _authenticating = false;
  bool _startupPrompted = false;
  DateTime? _leftAt;
  bool _authCovered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _startupPrompted = true;
      if (ref.read(biometricProvider)) _unlock();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      if (_authenticating) {
        _authCovered = true;
      } else {
        _leftAt ??= DateTime.now();
      }
    } else if (state == AppLifecycleState.resumed) {
      final covered = _authCovered;
      _authCovered = false;
      final leftAt = _leftAt;
      _leftAt = null;
      if (!ref.read(biometricProvider)) return;
      if (!_startupPrompted) return;
      if (covered) {
        return;
      }
      final lastSuccess = BiometricService.instance.lastSuccessAt;
      if (lastSuccess != null &&
          DateTime.now().difference(lastSuccess) < widget.relockAfter) {
        return;
      }
      final away = leftAt == null
          ? widget
                .relockAfter
          : DateTime.now().difference(leftAt);
      if (away < widget.relockAfter && _authed) return;
      _relockAndPrompt();
    }
  }

  void _relockAndPrompt() {
    if (!_authed) {
      _unlock();
      return;
    }
    setState(() => _authed = false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _unlock();
    });
  }

  Future<void> _unlock() async {
    if (_authenticating) return;
    _authenticating = true;
    try {
      final reason = (AppLocalizations.of(context) ?? l10nZh).unlockReason;
      final ok = await widget.authenticate(reason);
      if (mounted && ok) setState(() => _authed = true);
    } on BiometricUnavailableException {
      if (mounted) {
        await ref.read(biometricProvider.notifier).set(false);
        if (mounted) setState(() => _authed = true);
      }
    } catch (_) {
    } finally {
      _authenticating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(biometricProvider);
    final locked = enabled && !_authed;
    final l10n = AppLocalizations.of(context) ?? l10nZh;
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (locked)
          Positioned.fill(
            child: BlockSemantics(
              blocking: true,
              child: Scaffold(
                backgroundColor: ZT.bg,
                body: SafeArea(
                  child: LayoutBuilder(
                    builder: (context, viewport) => SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewport.maxHeight,
                        ),
                        child: Align(
                          alignment: const Alignment(0, -0.55),
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/brand/mark.png',
                                    width: 72,
                                    height: 72,
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'ZREMOTE',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 6,
                                      color: ZT.textLo,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.lockTitle,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: ZT.textHi,
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  FilledButton.icon(
                                    onPressed: _unlock,
                                    icon: const Icon(Icons.lock_open, size: 18),
                                    label: Text(l10n.unlockButton),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
