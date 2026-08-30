import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'services/biometric.dart';
import 'state/session_pool.dart';
import 'theme.dart';
import 'ui/app_shell.dart';

void main() {
  runApp(const ProviderScope(child: ZRemoteApp()));
}

class ZRemoteApp extends ConsumerWidget {
  const ZRemoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'ZRemote',
      debugShowCheckedModeBanner: false,
      theme: ZT.theme(),
      home: const AppShell(),
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
  bool _startupGraceElapsed = false;
  DateTime? _leftAt;
  bool _authCovered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _startupGraceElapsed = true);
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
      if (!_startupGraceElapsed) return;
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
      final ok = await widget.authenticate('验证以解锁 ZRemote');
      if (mounted && ok) setState(() => _authed = true);
    } catch (_) {
    } finally {
      _authenticating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(biometricProvider);
    final locked = enabled && !_authed && _startupGraceElapsed;
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
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ZT.surface,
                          border: Border.all(color: ZT.hairline),
                        ),
                        child: const Icon(
                          Icons.fingerprint,
                          size: 42,
                          color: ZT.accent,
                        ),
                      ),
                      const SizedBox(height: 28),
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
                      const Text(
                        '已锁定',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: ZT.textHi,
                        ),
                      ),
                      const SizedBox(height: 28),
                      FilledButton.icon(
                        onPressed: _unlock,
                        icon: const Icon(Icons.lock_open, size: 18),
                        label: const Text('解锁'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
