import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../l10n/app_localizations.dart';
import '../models/device.dart';
import '../services/app_settings.dart';
import '../services/device_import.dart';
import '../services/keepalive.dart';
import '../services/link_builder.dart';
import '../state/app_lifecycle.dart';
import '../state/session_pool.dart';
import '../state/keepalive.dart';
import '../state/session_status.dart';
import '../state/event_feed.dart';
import '../theme.dart';
import '../models/device_label.dart';
import 'section_label.dart';
import 'settings_page.dart';
import 'unread_badge.dart';

class ManagePage extends ConsumerWidget {
  const ManagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(deviceListProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 150),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 14, 4, 0),
              child: Row(
                children: [
                  Image.asset('assets/brand/mark.png', width: 30, height: 30),
                  const SizedBox(width: 10),
                  const Text(
                    'ZREMOTE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                      color: ZT.textLo,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: Text(
                l10n.manageTitle,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: ZT.textHi,
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (devices.isEmpty)
              _EmptyHint(onScan: () => _openScanner(context, ref))
            else ...[
              SectionLabel(l10n.devicesCount(devices.length)),
              ...devices.map((d) => _DeviceCard(device: d)),
            ],
            const SizedBox(height: 12),
            const _SettingsEntry(),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'paste',
            tooltip: l10n.importPasteTooltip,
            onPressed: () => _showPasteDialog(context, ref),
            child: const Icon(Icons.content_paste, size: 20),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'scan',
            onPressed: () => _openScanner(context, ref),
            icon: const Icon(Icons.qr_code_scanner),
            label: Text(l10n.importScanLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _openScanner(BuildContext context, WidgetRef ref) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const ScannerPage(),
      ),
    );
  }

  Future<void> _showPasteDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final text = await showDialog<String>(
      context: context,
      builder: (dialogContext) => _PasteDialog(l10n: l10n),
    );
    if (text == null || !context.mounted) return;
    await _importFromText(context, ref, text);
  }

  Future<void> _importFromText(
    BuildContext context,
    WidgetRef ref,
    String text,
  ) async {
    final device = LinkBuilder.parse(text);
    if (device == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.importFailed)),
        );
      }
      return;
    }
    final devices = ref.read(deviceListProvider);
    final dup = findDuplicateBySid(devices, device);
    if (dup != null) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.importDuplicate(dup.displayName(l10n)))),
        );
        final index = ref.read(deviceListProvider).indexOf(dup);
        if (index >= 0) ref.read(activeTabProvider.notifier).set(index);
      }
      return;
    }
    if (devices.length == 5 && context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.manyDevicesTitle),
          content: Text(l10n.manyDevicesBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.commonGotIt),
            ),
          ],
        ),
      );
    }
    await ref.read(deviceListProvider.notifier).add(device);
    ref.read(activeTabProvider.notifier).set(devices.length);
  }
}

class _PasteDialog extends StatefulWidget {
  const _PasteDialog({required this.l10n});

  final AppLocalizations l10n;

  @override
  State<_PasteDialog> createState() => _PasteDialogState();
}

class _PasteDialogState extends State<_PasteDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l10n.pasteDialogTitle),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        autofocus: true,
        style: const TextStyle(fontSize: 13),
        decoration: const InputDecoration(
          hintText: 'https://zcode.z.ai/remote/v4?sid=...&hash=...',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text(widget.l10n.importButton),
        ),
      ],
    );
  }
}

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.l10n, required this.initialName});

  final AppLocalizations l10n;
  final String initialName;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final _controller = TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l10n.renameDialogTitle),
      content: TextField(controller: _controller, autofocus: true),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text(widget.l10n.commonSave),
        ),
      ],
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.onScan});

  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ZT.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ZT.hairline),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: ZT.accent.withValues(alpha: 0.10),
            ),
            child: const Icon(Icons.qr_code_2, size: 32, color: ZT.accent),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.emptyTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: ZT.textHi,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.emptyBody,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, height: 1.5, color: ZT.textLo),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onScan,
            icon: const Icon(Icons.qr_code_scanner, size: 18),
            label: Text(l10n.importScanLabel),
          ),
        ],
      ),
    );
  }
}

class _DeviceCard extends ConsumerWidget {
  const _DeviceCard({required this.device});

  final RemoteDevice device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(sessionStatusProvider)[device.id];
    final feed = ref.watch(eventFeedProvider)[device.id];
    final l10n = AppLocalizations.of(context)!;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          final index = ref.read(deviceListProvider).indexOf(device);
          ref.read(activeTabProvider.notifier).set(index);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ZT.surfaceHi,
                ),
                child: const Icon(
                  Icons.desktop_windows,
                  size: 20,
                  color: ZT.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.displayName(l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: ZT.textHi,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.deviceAddedOn(
                        '${device.createdAt.month}/${device.createdAt.day}',
                      ),
                      style: const TextStyle(fontSize: 12, color: ZT.textLo),
                    ),
                  ],
                ),
              ),
              UnreadBadge(feed: feed),
              Tooltip(
                message: switch (status) {
                  SessionStatus.live => l10n.statusLive,
                  SessionStatus.error => l10n.statusError,
                  SessionStatus.loading || null => l10n.statusConnecting,
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ZT.statusColor(status),
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: ZT.textLo),
                onSelected: (action) async {
                  switch (action) {
                    case 'open':
                      final index = ref
                          .read(deviceListProvider)
                          .indexOf(device);
                      ref.read(activeTabProvider.notifier).set(index);
                    case 'rename':
                      await _rename(context, ref);
                    case 'delete':
                      await _confirmDelete(context, ref);
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'open',
                    child: Text(l10n.menuOpenSession),
                  ),
                  PopupMenuItem(value: 'rename', child: Text(l10n.menuRename)),
                  PopupMenuItem(value: 'delete', child: Text(l10n.menuDelete)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _rename(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => _RenameDialog(
        l10n: l10n,
        initialName: device.label,
      ),
    );
    final ok = name != null && name.trim().isNotEmpty;
    if (ok && context.mounted) {
      await ref.read(deviceListProvider.notifier).rename(device.id, name);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteDeviceTitle(device.displayName(l10n))),
        content: Text(l10n.deleteDeviceBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: ZT.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.menuDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    if (!context.mounted) return;
    await ref.read(deviceListProvider.notifier).remove(device.id);
  }
}

class _SettingsEntry extends ConsumerStatefulWidget {
  const _SettingsEntry();

  @override
  ConsumerState<_SettingsEntry> createState() => _SettingsEntryState();
}

class _SettingsEntryState extends ConsumerState<_SettingsEntry> {
  bool _risk = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final risk = await _computeRisk();
    if (mounted) setState(() => _risk = risk);
  }

  Future<bool> _computeRisk() async {
    if (ref.read(deviceListProvider).isEmpty) return false;
    if (!ref.read(keepAliveEnabledProvider)) return true;
    final service = KeepAliveService.instance;
    final results = await Future.wait([
      service.isBatteryIgnored,
      service.isBlocked,
    ]);
    return !results[0] || results[1];
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(keepAliveEnabledProvider, (_, _) => _refresh());
    ref.listen(appLifecycleProvider, (prev, next) {
      if (next == AppLifecycleState.resumed) _refresh();
    });
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ZT.accent.withValues(alpha: 0.10),
          ),
          child: const Icon(
            Icons.settings_outlined,
            size: 20,
            color: ZT.accent,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.settingsEntryTitle,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          AppLocalizations.of(context)!.settingsEntrySubtitle,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: _risk
            ? Tooltip(
                message: AppLocalizations.of(context)!.settingsEntryRisk,
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 20,
                  color: ZT.danger,
                ),
              )
            : const Icon(Icons.chevron_right, color: ZT.textLo),
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const SettingsPage())),
      ),
    );
  }
}

class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key});

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage>
    with WidgetsBindingObserver {
  String? _lastCode;
  DateTime _lastAccept = DateTime.fromMillisecondsSinceEpoch(0);
  bool _navigating = false;

  MobileScannerController? _controller;

  bool _permDenied = false;

  int _scannerGeneration = 0;

  @visibleForTesting
  void debugMarkPermDenied() => _permDenied = true;

  @visibleForTesting
  int get debugScannerGeneration => _scannerGeneration;

  Future<void> _guarded(Future<void> Function() f) async {
    try {
      await f();
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null) return;
    switch (state) {
      case AppLifecycleState.resumed:
        if (_permDenied) {
          _permDenied = false;
          setState(() {
            _scannerGeneration++;
            _controller = MobileScannerController();
          });
          _guarded(controller.dispose);
        } else {
          _guarded(controller.start);
        }
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _guarded(controller.stop);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppLocalizations.of(context)!.scannerTitle),
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black54, Colors.transparent],
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            key: ValueKey(_scannerGeneration),
            controller: _controller,
            onDetect: (capture) => _onDetect(capture),
            errorBuilder: (context, error) {
              if (error.errorCode != MobileScannerErrorCode.permissionDenied) {
                return const SizedBox.shrink();
              }
              _permDenied = true;
              return _PermDeniedView();
            },
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _ScannerOverlayPainter()),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 56,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.54),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  AppLocalizations.of(context)!.scannerHint,
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_navigating) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;
    final now = DateTime.now();
    if (code == _lastCode && now.difference(_lastAccept).inSeconds < 2) return;
    _lastCode = code;
    _lastAccept = now;

    final device = LinkBuilder.parse(code);
    if (device == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.invalidQr)),
        );
      }
      return;
    }

    final dup = findDuplicateBySid(ref.read(deviceListProvider), device);
    if (dup != null) {
      _navigating = true;
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.importDuplicate(dup.displayName(l10n)))),
      );
      Navigator.of(context).pop();
      final index = ref.read(deviceListProvider).indexOf(dup);
      if (index >= 0) ref.read(activeTabProvider.notifier).set(index);
      return;
    }

    _navigating = true;
    await ref.read(deviceListProvider.notifier).add(device);
    if (!mounted) return;
    Navigator.of(context).pop();
    ref
        .read(activeTabProvider.notifier)
        .set(ref.read(deviceListProvider).length - 1);
  }
}

class _PermDeniedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.no_photography_outlined,
              size: 44,
              color: Colors.white54,
            ),
            const SizedBox(height: 18),
            Text(
              l10n.scannerPermTitle,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.scannerPermBody,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.white70),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: AppSettings.open,
              icon: const Icon(Icons.settings_outlined, size: 18),
              label: Text(l10n.scannerPermOpenSettings),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const windowSize = 260.0;
    const radius = 20.0;
    const arm = 28.0;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: windowSize,
      height: windowSize,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));

    final mask = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(rrect);
    canvas.drawPath(
      mask,
      Paint()..color = Colors.black.withValues(alpha: 0.55),
    );

    final bracket = Paint()
      ..color = ZT.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final l = rect.left, t = rect.top, r = rect.right, b = rect.bottom;
    final path = Path()
      ..moveTo(l, t + arm)
      ..lineTo(l, t)
      ..lineTo(l + arm, t)
      ..moveTo(r - arm, t)
      ..lineTo(r, t)
      ..lineTo(r, t + arm)
      ..moveTo(l, b - arm)
      ..lineTo(l, b)
      ..lineTo(l + arm, b)
      ..moveTo(r - arm, b)
      ..lineTo(r, b)
      ..lineTo(r, b - arm);
    canvas.drawPath(path, bracket);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
