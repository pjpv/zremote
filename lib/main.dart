import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/app_localizations.dart';
import 'models/device_label.dart';
import 'services/biometric.dart';
import 'services/device_store.dart';
import 'services/notifier.dart';
import 'state/keepalive.dart';
import 'state/locale.dart';
import 'state/theme_mode.dart';
import 'state/session_pool.dart';
import 'theme.dart';
import 'state/app_lifecycle.dart';
import 'ui/app_shell.dart';
import 'ui/bevel_card.dart';
import 'ui/showcase_bits.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotifierService.instance.init();
  final store = DeviceStore.instance;
  final initialLocale = await store.localeSetting();
  final initialBiometric = await store.biometricEnabled();
  final initialKeepAlive = await store.keepAliveEnabled();
  final initialThemeMode = await store.themeModeSetting();
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
        themeModeSettingProvider.overrideWith(
          () => ThemeModeSettingNotifier(initial: initialThemeMode),
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
    final themeSetting = ref.watch(themeModeSettingProvider);
    return MaterialApp(
      title: 'ZRemote',
      debugShowCheckedModeBanner: false,
      theme: ZT.theme(Brightness.light),
      darkTheme: ZT.theme(Brightness.dark),
      themeMode: resolveThemeMode(themeSetting),
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
    this.haloAnimated = true,
  });

  final Widget child;

  final Duration relockAfter;

  final Future<bool> Function(String reason) authenticate;

  final bool haloAnimated;

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
                backgroundColor: context.zt.bg,
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
                                  _SenseHalo(animated: widget.haloAnimated),
                                  const SizedBox(height: 24),
                                  Text(
                                    l10n.lockTitle,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.4,
                                      color: context.zt.textHi,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  BevelCard(
                                    onTap: _unlock,
                                    margin: EdgeInsets.zero,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 14,
                                    ),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minHeight: 36,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: context.zt.accentSubtle,
                                            ),
                                            child: Icon(
                                              Icons.fingerprint,
                                              size: 26,
                                              color: context.zt.accent,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  l10n.lockActionPrimary,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: context.zt.textHi,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  l10n.lockActionFallback,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: context.zt.textLo,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: context.zt.textLo,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 36),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.shield_outlined,
                                        size: 12,
                                        color: context.zt.textTertiary,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        l10n.lockFooter,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: context.zt.textTertiary,
                                        ),
                                      ),
                                    ],
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

class _SenseHalo extends StatefulWidget {
  const _SenseHalo({required this.animated});

  final bool animated;

  @override
  State<_SenseHalo> createState() => _SenseHaloState();
}

class _SenseHaloState extends State<_SenseHalo>
    with SingleTickerProviderStateMixin {
  AnimationController? _breath;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      _breath = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2400),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _breath?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final glow = IgnorePointer(
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              zt.accent.withValues(alpha: 0.13),
              zt.accent.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
    final ring = CustomPaint(
      size: const Size(130, 130),
      painter: ZrDashedBorderPainter(
        color: zt.accent.withValues(alpha: 0.4),
        radius: 65,
        strokeWidth: 1.5,
        dash: 6,
        gap: 5,
      ),
    );
    final iconBox = Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: zt.surfaceHi,
        border: Border.all(color: zt.hairline, width: 0.8),
      ),
      child: Center(
        child: Image.asset('assets/brand/mark.png', width: 42, height: 42),
      ),
    );
    final controller = _breath;
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          glow,
          if (controller == null)
            ring
          else
            ScaleTransition(
              scale: Tween<double>(begin: 1.0, end: 1.06).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: Curves.easeInOut,
                ),
              ),
              child: ring,
            ),
          iconBox,
        ],
      ),
    );
  }
}
