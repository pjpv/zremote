import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'bevel_card.dart';
import 'inlaid_well.dart';
import 'section_label.dart';
import 'sheet_shell.dart';
import 'showcase_bits.dart';
import 'tactile_button.dart';
import 'settings_page.dart';

class ManagePage extends ConsumerWidget {
  const ManagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(deviceListProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: context.zt.hairline, width: 0.8),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 6, 8, 10),
              child: SizedBox(
                height: 48,
                child: Row(
                  children: [
                    Image.asset('assets/brand/mark.png', width: 24, height: 24),
                    const SizedBox(width: 10),
                    Text(
                      'ZREMOTE',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                        color: context.zt.textHi,
                      ),
                    ),
                    const Spacer(),
                    if (devices.isNotEmpty)
                      IconButton(
                        tooltip: l10n.importScanLabel,
                        onPressed: () => _showImportSheet(context, ref),
                        icon: Icon(Icons.add, color: context.zt.textLo),
                      ),
                    const _SettingsGear(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 40),
                children: [
                  if (devices.isEmpty)
                    _EmptyHint(
                      onScan: () => _openScanner(context, ref),
                      onPaste: () => _showPasteDialog(context, ref),
                    )
                  else ...[
                    _TelemetryBanner(devices: devices),
                    const SizedBox(height: 12),
                    SectionLabel(l10n.pairedHostsSection(devices.length)),
                    ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 2, bottom: 2),
                      buildDefaultDragHandles: false,
                      onReorder: (oldIndex, newIndex) => ref
                          .read(deviceListProvider.notifier)
                          .reorder(oldIndex, newIndex),
                      proxyDecorator: (child, index, animation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (context, _) {
                            final animValue = Curves.easeInOut.transform(
                              animation.value,
                            );
                            final scale = 1.0 + 0.02 * animValue;
                            return Transform.scale(
                              scale: scale,
                              child: Material(
                                color: Colors.transparent,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                surfaceTintColor: Colors.transparent,
                                type: MaterialType.transparency,
                                child: child,
                              ),
                            );
                          },
                        );
                      },
                      children: [
                        for (var i = 0; i < devices.length; i++)
                          _DeviceCard(
                            key: ValueKey(devices[i].id),
                            device: devices[i],
                            index: i,
                          ),
                      ],
                    ),
                    _AddDeviceCard(
                      onTap: () => _showImportSheet(context, ref),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImportSheet(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final action = await showZrSheet<String>(
      context: context,
      builder: (sheetContext) {
        final zt = sheetContext.zt;
        Widget entry({
          required IconData icon,
          required String label,
          required String sub,
          required String value,
        }) => ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: zt.accentSubtle,
            ),
            child: Icon(icon, size: 19, color: zt.accent),
          ),
          subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
          trailing: Icon(Icons.chevron_right, size: 20, color: zt.textLo),
          title: Text(label),
          onTap: () => Navigator.pop(sheetContext, value),
        );
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Text(
                l10n.addDeviceCardTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: zt.textHi,
                ),
              ),
            ),
            entry(
              icon: Icons.qr_code_scanner,
              label: l10n.importScanLabel,
              sub: l10n.importSheetScanSub,
              value: 'scan',
            ),
            entry(
              icon: Icons.content_paste,
              label: l10n.importPasteTooltip,
              sub: l10n.importSheetPasteSub,
              value: 'paste',
            ),
          ],
        );
      },
    );
    if (action == null || !context.mounted) return;
    switch (action) {
      case 'scan':
        await _openScanner(context, ref);
      case 'paste':
        await _showPasteDialog(context, ref);
    }
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
  const _PasteDialog({required this.l10n, this.title, this.actionLabel});

  final AppLocalizations l10n;

  final String? title;
  final String? actionLabel;

  @override
  State<_PasteDialog> createState() => _PasteDialogState();
}

class _PasteDialogState extends State<_PasteDialog> {
  final _controller = TextEditingController();

  bool _clipReady = false;

  @override
  void initState() {
    super.initState();
    _probeClipboard();
  }

  Future<void> _probeClipboard() async {
    try {
      final text = await Clipboard.getData('text/plain');
      final value = text?.text;
      if (value == null || value.isEmpty) return;
      if (LinkBuilder.parse(value) != null && mounted) {
        setState(() => _clipReady = true);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fillFromClipboard() async {
    try {
      final text = await Clipboard.getData('text/plain');
      final value = text?.text;
      if (value == null || value.isEmpty) return;
      _controller
        ..text = value
        ..selection = TextSelection.collapsed(offset: value.length);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final zt = context.zt;
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: zt.accentSubtle,
                ),
                child: Icon(Icons.content_paste, size: 17, color: zt.accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.title ?? l10n.pasteDialogTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: zt.textHi,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _RoundCloseButton(onTap: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.pasteDialogSub,
            style: TextStyle(fontSize: 11.5, color: zt.textLo),
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.pasteFieldLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: zt.textLo,
                  ),
                ),
                Text(
                  l10n.pasteCharCount(value.text.characters.length, 256),
                  style: zrMono(fontSize: 10, color: zt.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) => TextField(
              controller: _controller,
              maxLines: 3,
              maxLength: 256,
              autofocus: true,
              style: zrMono(fontSize: 13, weight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: 'https://zcode.z.ai/remote/v4?sid=...&hash=...',
                counterText: '',
                suffixIcon: value.text.isEmpty
                    ? null
                    : IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: _controller.clear,
                        icon: Icon(Icons.close_rounded,
                            size: 16, color: zt.textTertiary),
                      ),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              if (!_clipReady || value.text.isNotEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _SmartClipPill(
                  detected: l10n.smartClipDetected,
                  action: l10n.smartClipAction,
                  onTap: _fillFromClipboard,
                ),
              );
            },
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              final parsed = value.text.isEmpty
                  ? null
                  : LinkBuilder.parse(value.text);
              if (parsed == null) return const SizedBox(height: 8);
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ZrInterpreterBar(text: l10n.pasteValidFormat),
              );
            },
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) => Row(
              children: [
                Expanded(
                  child: TactileButton(
                    label: l10n.commonCancel,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TactileButton(
                    variant: TactileVariant.primary,
                    label: widget.actionLabel ?? l10n.importButton,
                    onPressed: value.text.trim().isEmpty
                        ? null
                        : () => Navigator.pop(context, _controller.text),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

Future<void> _applyReplaceLink(
  BuildContext context,
  WidgetRef ref,
  RemoteDevice target,
  RemoteDevice parsed,
) async {
  final l10n = AppLocalizations.of(context)!;
  final dup = findDuplicateBySidExcept(
    ref.read(deviceListProvider),
    parsed,
    target.id,
  );
  if (dup != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.replaceDuplicate(dup.displayName(l10n)))),
    );
    return;
  }
  await ref.read(deviceListProvider.notifier).replaceLink(target.id, parsed);
  if (!context.mounted) return;
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(l10n.replaceDone)));
  final index = ref
      .read(deviceListProvider)
      .indexWhere((d) => d.id == target.id);
  if (index >= 0) ref.read(activeTabProvider.notifier).set(index);
}

class _RoundCloseButton extends StatelessWidget {
  const _RoundCloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : zt.surfaceHover,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : zt.hairline,
            width: 0.8,
          ),
        ),
        child: Icon(Icons.close_rounded, size: 15, color: zt.textLo),
      ),
    );
  }
}

class _SmartClipPill extends StatelessWidget {
  const _SmartClipPill({
    required this.detected,
    required this.action,
    required this.onTap,
  });

  final String detected;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: CustomPaint(
        painter: ZrDashedBorderPainter(
          color: zt.accent.withValues(alpha: isDark ? 0.5 : 0.45),
          radius: 12,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, size: 14, color: zt.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detected,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: zt.textHi,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      action,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: zt.accent,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 16, color: zt.accent),
            ],
          ),
        ),
      ),
    );
  }
}

class _RenameSheet extends StatefulWidget {
  const _RenameSheet({required this.l10n, required this.initialName});

  final AppLocalizations l10n;
  final String initialName;

  @override
  State<_RenameSheet> createState() => _RenameSheetState();
}

class _RenameSheetState extends State<_RenameSheet> {
  late final _controller = TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final zt = context.zt;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.renameDialogTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: zt.textHi,
                  ),
                ),
              ),
              _RoundCloseButton(onTap: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.renameSubtitle,
            style: TextStyle(fontSize: 12, color: zt.textLo),
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.renameFieldLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: zt.textLo,
                  ),
                ),
                Text(
                  l10n.renameCounter(value.text.characters.length, 32),
                  style: zrMono(fontSize: 10, color: zt.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          InlaidWell(
            padding: EdgeInsets.zero,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) => TextField(
                controller: _controller,
                autofocus: true,
                maxLength: 32,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  filled: false,
                  border: InputBorder.none,
                  counterText: '',
                  suffixIcon: value.text.isEmpty
                      ? null
                      : IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: _controller.clear,
                          icon: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: zt.textTertiary,
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.renameHint,
            style: TextStyle(fontSize: 10.5, color: zt.textTertiary),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) => Row(
              children: [
                Expanded(
                  child: TactileButton(
                    label: l10n.commonCancel,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TactileButton(
                    variant: TactileVariant.primary,
                    label: l10n.renameSave,
                    onPressed:
                        value.text.trim().isEmpty
                            ? null
                            : () => Navigator.pop(context, _controller.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

IconData _devicePlatformIcon(String displayName) {
  final name = displayName.toLowerCase();
  if (name.contains('mac') ||
      name.contains('darwin') ||
      name.contains('apple') ||
      name.contains('osx')) {
    return Icons.laptop_mac;
  }
  if (name.contains('win') || name.contains('pc')) {
    return Icons.laptop_windows;
  }
  if (name.contains('linux') ||
      name.contains('ubuntu') ||
      name.contains('debian') ||
      name.contains('server') ||
      name.contains('arch')) {
    return Icons.terminal;
  }
  return Icons.desktop_windows;
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.onScan, required this.onPaste});

  final VoidCallback onScan;
  final VoidCallback onPaste;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final zt = context.zt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BevelCard(
          radius: 22,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              _TopologyFigure(),
              const SizedBox(height: 20),
              Text(
                l10n.emptyTitle,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: zt.textHi,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.emptyBody,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, height: 1.5, color: zt.textLo),
              ),
            ],
          ),
        ),
        BevelCard(
          radius: 16,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: zt.accentSubtle,
                  border: Border.all(color: zt.accentBorder, width: 0.8),
                ),
                child: Icon(Icons.tune, size: 16, color: zt.accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsEntryTitle,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: zt.textHi,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.settingsEntrySubtitle,
                      style: TextStyle(fontSize: 11, color: zt.textLo),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 20, color: zt.textLo),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: zt.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: zt.hairline, width: 0.8),
          ),
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              Expanded(
                child: TactileButton(
                  label: l10n.importPasteTooltip,
                  icon: const Icon(Icons.content_paste, size: 15),
                  onPressed: onPaste,
                ),
              ),
              Container(
                width: 0.8,
                height: 18,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                color: zt.hairline,
              ),
              Expanded(
                child: TactileButton(
                  variant: TactileVariant.primary,
                  label: l10n.importScanLabel,
                  icon: const Icon(Icons.qr_code_scanner, size: 15),
                  onPressed: onScan,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopologyFigure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    Widget node(IconData icon, String label, {required bool accent}) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: accent ? zt.accentSubtle : zt.field,
              border: Border.all(
                color: accent ? zt.accentBorder : zt.hairline,
                width: 0.8,
              ),
            ),
            child: Icon(
              icon,
              size: 22,
              color: accent ? zt.accent : zt.textLo,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 10.5, color: zt.textLo),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        node(Icons.desktop_windows, 'ZCode', accent: false),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomPaint(
                size: const Size(64, 12),
                painter: ZrDashedLinePainter(color: zt.accent.withValues(alpha: 0.55)),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 2.5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: zt.accentSubtle,
                  border: Border.all(color: zt.accentBorder, width: 0.7),
                ),
                child: Text(
                  'RELAY',
                  style: zrMono(fontSize: 9, color: zt.accent),
                ),
              ),
              CustomPaint(
                size: const Size(64, 12),
                painter: ZrDashedLinePainter(color: zt.accent.withValues(alpha: 0.55)),
              ),
            ],
          ),
        ),
        node(Icons.phone_iphone, 'ZRemote', accent: true),
      ],
    );
  }
}

class _TelemetryBanner extends ConsumerWidget {
  const _TelemetryBanner({required this.devices});

  final List<RemoteDevice> devices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statuses = ref.watch(sessionStatusProvider);
    final feeds = ref.watch(eventFeedProvider);
    final online = devices
        .where((d) => statuses[d.id] == SessionStatus.live)
        .length;
    final unread = [
      for (final d in devices) feeds[d.id]?.unread ?? 0,
    ].fold(0, (a, b) => a + b);

    final onlineValue = (online > 0 && online < devices.length)
        ? '$online/${devices.length}'
        : (online == 0 && devices.isNotEmpty ? '0/${devices.length}' : '$online');
    return ZrTelemetryBanner(
      items: [
        ZrTelemetryItem(
          label: l10n.telemetryBound,
          value: onlineValue,
          unit: l10n.telemetryOnlineUnit,
          unitColor: online > 0 ? context.zt.live : context.zt.textLo,
          ledColor: online > 0 ? context.zt.live : context.zt.warn,
        ),
        ZrTelemetryItem(
          label: l10n.telemetryUnread,
          value: '$unread',
          unit: l10n.telemetryUnreadUnit,
          unitColor: unread > 0 ? context.zt.accent : context.zt.textLo,
          ledColor: unread > 0 ? context.zt.warn : null,
        ),
      ],
    );
  }
}

class _DeviceCard extends ConsumerWidget {
  const _DeviceCard({super.key, required this.device, required this.index});

  final RemoteDevice device;

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(sessionStatusProvider)[device.id];
    final feed = ref.watch(eventFeedProvider)[device.id];
    final isActiveTab =
        ref.watch(activeTabProvider) ==
        ref.watch(deviceListProvider).indexOf(device);
    final l10n = AppLocalizations.of(context)!;
    final zt = context.zt;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final displayName = device.displayName(l10n);
    final platformIcon = _devicePlatformIcon(displayName);
    final live = status == SessionStatus.live;
    final unread = feed?.unread ?? 0;

    final (chipColor, chipLabel) = switch (status) {
      SessionStatus.live => (zt.live, l10n.chipOnline),
      SessionStatus.error => (zt.danger, l10n.chipOffline),
      SessionStatus.loading || null => (zt.warn, l10n.statusConnecting),
    };

    return BevelCard(
      radius: 12,
      accent: isActiveTab,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: () {
        final index = ref.read(deviceListProvider).indexOf(device);
        ref.read(activeTabProvider.notifier).set(index);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: live
                      ? (isDark
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                zt.accent.withValues(alpha: 0.16),
                                zt.accent.withValues(alpha: 0.05),
                              ],
                            )
                          : null)
                      : null,
                  color: live
                      ? (isDark ? null : zt.accentSubtle)
                      : (isDark ? const Color(0xFF131620) : zt.field),
                  border: Border.all(
                    color: live
                        ? zt.accentBorder.withValues(alpha: isDark ? 0.45 : 0.6)
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : zt.hairline),
                    width: 0.8,
                  ),
                ),
                child: Icon(
                  platformIcon,
                  size: 21,
                  color: live ? zt.accent : zt.textLo,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          color: zt.textHi,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ZrStatusChip(
                      label: chipLabel,
                      color: chipColor,
                      withLed: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    splashRadius: 16,
                    tooltip: '',
                    color: isDark ? const Color(0xFF1B1E26) : zt.surfaceHi,
                    elevation: 12,
                    shadowColor: Colors.black.withValues(alpha: 0.6),
                    surfaceTintColor: Colors.transparent,
                    icon: SizedBox(
                      width: 28,
                      height: 28,
                      child: Center(
                        child: Icon(
                          Icons.more_horiz,
                          size: 18,
                          color: isDark ? Colors.white54 : zt.textLo,
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.16)
                            : zt.hairlineBright,
                        width: 1.0,
                      ),
                    ),
                    onSelected: (action) async {
                      switch (action) {
                        case 'rename':
                          await _rename(context, ref);
                        case 'replace':
                          await _replace(context, ref);
                        case 'delete':
                          await _confirmDelete(context, ref);
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'rename',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined,
                                size: 17, color: zt.textLo),
                            const SizedBox(width: 10),
                            Text(l10n.menuRename),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'replace',
                        child: Row(
                          children: [
                            Icon(Icons.sync_alt,
                                size: 17, color: zt.textLo),
                            const SizedBox(width: 10),
                            Text(l10n.menuReplace),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                size: 17, color: zt.danger),
                            const SizedBox(width: 10),
                            Text(
                              l10n.menuDelete,
                              style: TextStyle(color: zt.danger),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 2),
                  ReorderableDragStartListener(
                    index: index,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: Center(
                          child: Icon(
                            Icons.drag_indicator_rounded,
                            size: 18,
                            color: isDark ? Colors.white30 : zt.textTertiary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 0.8,
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : zt.hairline,
          ),
          const SizedBox(height: 9),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _metricPod(
                  context,
                  icon: unread > 0
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_none_rounded,
                  value: unread > 0
                      ? l10n.telemetryUnreadCount(unread)
                      : l10n.metricUnreadZero,
                  valueColor: unread > 0 ? zt.accent : zt.textTertiary,
                  isAlert: unread > 0,
                  isDark: isDark,
                ),
              ),
              Container(
                width: 0.8,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : zt.hairline,
              ),
              Expanded(
                child: _credentialPod(
                  context,
                  dateText: l10n.deviceAddedOn(
                    '${device.createdAt.month}/${device.createdAt.day}',
                  ),
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricPod(
    BuildContext context, {
    required IconData icon,
    required String value,
    required Color valueColor,
    required bool isAlert,
    required bool isDark,
  }) {
    final zt = context.zt;
    final badgeBg = isAlert
        ? zt.accent.withValues(alpha: 0.12)
        : (isDark ? Colors.white.withValues(alpha: 0.04) : zt.surfaceHover);
    final badgeBorder = isAlert
        ? zt.accent.withValues(alpha: 0.30)
        : (isDark ? Colors.white.withValues(alpha: 0.07) : zt.hairline);
    final iconColor = isAlert ? zt.accent : zt.textTertiary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: badgeBg,
            border: Border.all(color: badgeBorder, width: 0.7),
          ),
          child: Center(
            child: Icon(icon, size: 13.5, color: iconColor),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isAlert ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: -0.1,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _credentialPod(
    BuildContext context, {
    required String dateText,
    required bool isDark,
  }) {
    final zt = context.zt;
    final badgeBg = isDark
        ? Colors.white.withValues(alpha: 0.04)
        : zt.surfaceHover;
    final badgeBorder = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : zt.hairline;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: badgeBg,
            border: Border.all(
              color: badgeBorder,
              width: 0.7,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.shield_outlined,
              size: 13.5,
              color: zt.textTertiary,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            dateText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.1,
              color: zt.textTertiary,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _rename(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final name = await showZrSheet<String>(
      context: context,
      builder: (sheetContext) =>
          _RenameSheet(l10n: l10n, initialName: device.label),
    );
    final ok = name != null && name.trim().isNotEmpty;
    if (ok && context.mounted) {
      await ref.read(deviceListProvider.notifier).rename(device.id, name);
    }
  }

  Future<void> _replace(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final action = await showZrSheet<String>(
      context: context,
      builder: (sheetContext) {
        final zt = sheetContext.zt;
        Widget entry({
          required IconData icon,
          required String label,
          required String sub,
          required String value,
        }) => Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          decoration: BoxDecoration(
            color: zt.surfaceHi,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: zt.hairline, width: 0.8),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: zt.accentSubtle,
              ),
              child: Icon(icon, size: 19, color: zt.accent),
            ),
            trailing: Icon(Icons.chevron_right, size: 20, color: zt.textLo),
            title: Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: zt.textHi,
              ),
            ),
            subtitle: Text(
              sub,
              style: TextStyle(fontSize: 11.5, color: zt.textLo),
            ),
            onTap: () => Navigator.pop(sheetContext, value),
          ),
        );
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.replaceSheetTitle,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: zt.textHi,
                          ),
                        ),
                      ),
                      _RoundCloseButton(
                        onTap: () => Navigator.pop(sheetContext),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.replaceSheetBody(device.displayName(l10n)),
                    style: TextStyle(fontSize: 13, color: zt.textLo),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            entry(
              icon: Icons.qr_code_scanner,
              label: l10n.replaceScan,
              sub: l10n.replaceScanSub,
              value: 'scan',
            ),
            entry(
              icon: Icons.content_paste,
              label: l10n.replacePaste,
              sub: l10n.replacePasteSub,
              value: 'paste',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: SizedBox(
                width: double.infinity,
                child: TactileButton(
                  label: l10n.commonCancel,
                  onPressed: () => Navigator.pop(sheetContext),
                ),
              ),
            ),
          ],
        );
      },
    );
    if (action == null || !context.mounted) return;
    switch (action) {
      case 'scan':
        await Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => ScannerPage(replaceOf: device),
          ),
        );
      case 'paste':
        final text = await showDialog<String>(
          context: context,
          builder: (dialogContext) => _PasteDialog(
            l10n: l10n,
            title: l10n.replacePasteDialogTitle,
            actionLabel: l10n.commonSave,
          ),
        );
        if (text == null || !context.mounted) return;
        final parsed = LinkBuilder.parse(text);
        if (parsed == null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.importFailed),
              ),
            );
          }
          return;
        }
        await _applyReplaceLink(context, ref, device, parsed);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showZrSheet<bool>(
      context: context,
      builder: (sheetContext) {
        final zt = sheetContext.zt;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 4),
              Center(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: zt.danger.withValues(alpha: 0.12),
                    border: Border.all(
                      color: zt.danger.withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 24,
                    color: zt.danger,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.deleteDeviceTitle(device.displayName(l10n)),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: zt.textHi,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.deleteDeviceBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: zt.textLo,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TactileButton(
                      label: l10n.commonCancel,
                      onPressed: () => Navigator.pop(sheetContext, false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TactileButton(
                      variant: TactileVariant.danger,
                      label: l10n.deleteConfirmAction,
                      onPressed: () => Navigator.pop(sheetContext, true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    if (ok != true) return;
    if (!context.mounted) return;
    await ref.read(deviceListProvider.notifier).remove(device.id);
  }
}

class _SettingsGear extends ConsumerStatefulWidget {
  const _SettingsGear();

  @override
  ConsumerState<_SettingsGear> createState() => _SettingsGearState();
}

class _SettingsGearState extends ConsumerState<_SettingsGear> {
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

    return IconButton(
      tooltip: AppLocalizations.of(context)!.settingsEntryTitle,
      onPressed: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const SettingsPage())),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.settings_outlined,
            color: context.zt.textLo,
          ),
          if (_risk)
            Positioned(
              top: -1,
              right: -1,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.zt.danger,
                  boxShadow: [
                    BoxShadow(
                      color: context.zt.danger.withValues(alpha: 0.5),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddDeviceCard extends StatelessWidget {
  const _AddDeviceCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final zt = context.zt;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 28),
      child: Material(
        color: isDark ? const Color(0xFF101218) : zt.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: CustomPaint(
            painter: ZrDashedBorderPainter(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.16)
                  : zt.hairlineBright,
              radius: 12,
              strokeWidth: 1.2,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: zt.accentSubtle,
                    border: Border.all(
                      color: zt.accentBorder,
                      width: 0.8,
                    ),
                  ),
                  child: Icon(Icons.add, size: 20, color: zt.accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.addDeviceCardTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          color: zt.textHi,
                        ),
                      ),
                      const SizedBox(height: 2.5),
                      Text(
                        l10n.addDeviceCardSub,
                        style: TextStyle(fontSize: 11.5, color: zt.textLo),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.qr_code_scanner,
                  size: 20,
                  color: zt.textLo,
                ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key, this.replaceOf});

  final RemoteDevice? replaceOf;

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage>
    with WidgetsBindingObserver {
  String? _lastCode;
  DateTime _lastAccept = DateTime.fromMillisecondsSinceEpoch(0);
  bool _navigating = false;
  bool _torchOn = false;

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
        actions: [
          IconButton(
            tooltip: 'torch',
            onPressed: () {
              final controller = _controller;
              if (controller == null) return;
              setState(() => _torchOn = !_torchOn);
              _guarded(controller.toggleTorch);
            },
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _torchOn
                    ? const Color(0xFFFBBF24)
                    : Colors.white.withValues(alpha: 0.08),
                border: Border.all(
                  color: _torchOn
                      ? const Color(0xFFFBBF24)
                      : Colors.white.withValues(alpha: 0.12),
                ),
              ),
              child: Icon(
                _torchOn ? Icons.flashlight_on : Icons.flashlight_off,
                size: 19,
                color: _torchOn ? Colors.black : Colors.white70,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
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
            left: 24,
            right: 24,
            top: 0,
            bottom: 56,
            child: Align(
              alignment: const Alignment(0, 0.72),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.scannerPrimaryHint,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.replaceOf == null
                        ? AppLocalizations.of(context)!.scannerHint
                        : AppLocalizations.of(context)!.scannerReplaceHint,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
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

    final replaceOf = widget.replaceOf;
    if (replaceOf != null) {
      _navigating = true;
      final l10n = AppLocalizations.of(context)!;
      final dup = findDuplicateBySidExcept(
        ref.read(deviceListProvider),
        device,
        replaceOf.id,
      );
      if (dup != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.replaceDuplicate(dup.displayName(l10n)))),
        );
        Navigator.of(context).pop();
        return;
      }
      await ref
          .read(deviceListProvider.notifier)
          .replaceLink(replaceOf.id, device);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.replaceDone)));
      Navigator.of(context).pop();
      final index = ref
          .read(deviceListProvider)
          .indexWhere((d) => d.id == replaceOf.id);
      if (index >= 0) ref.read(activeTabProvider.notifier).set(index);
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
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.white70,
              ),
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
    const windowSize = 240.0;
    const radius = 20.0;
    const arm = 24.0;

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
      ..color = ZT.dark.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
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
    canvas.drawPath(
      path,
      Paint()
        ..color = ZT.dark.accent.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(path, bracket);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
