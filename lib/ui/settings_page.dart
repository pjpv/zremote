import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../l10n/app_localizations.dart';
import '../services/biometric.dart';
import '../services/keepalive.dart';
import '../state/app_lifecycle.dart';
import '../state/locale.dart';
import '../state/notification_prefs.dart';
import '../state/keepalive.dart';
import '../state/session_pool.dart';
import '../theme.dart';
import 'section_label.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: ZT.textLo),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    l10n.settingsTitle,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: ZT.textHi,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SectionLabel(l10n.sectionGeneral),
            const _LanguageTile(),
            const SizedBox(height: 12),
            SectionLabel(l10n.sectionSecurity),
            const _BiometricTile(),
            const SizedBox(height: 12),
            SectionLabel(l10n.sectionBackground),
            const _KeepAliveTile(),
            const _BatteryTile(),
            const SizedBox(height: 12),
            SectionLabel(l10n.sectionNotifications),
            const _NotificationCard(),
            const _VersionFooter(),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends ConsumerWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final setting = ref.watch(localeSettingProvider);
    final current = setting == kLocaleSystem
        ? l10n.languageSystem
        : localeDisplayName(setting);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ZT.accent.withValues(alpha: 0.10),
          ),
          child: const Icon(Icons.language, size: 22, color: ZT.accent),
        ),
        title: Text(
          l10n.languageTitle,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(current, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: ZT.textLo),
        onTap: () => _pick(context, ref),
      ),
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final setting = ref.read(localeSettingProvider);
    final choice = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(l10n.languageTitle),
        children: [
          _option(
            dialogContext,
            kLocaleSystem,
            l10n.languageSystem,
            setting == kLocaleSystem,
          ),
          for (final locale in AppLocalizations.supportedLocales)
            _option(
              dialogContext,
              locale.languageCode,
              localeDisplayName(locale.languageCode),
              setting == locale.languageCode,
            ),
        ],
      ),
    );
    if (choice == null || choice == setting) return;
    await ref.read(localeSettingProvider.notifier).set(choice);
  }

  Widget _option(
    BuildContext context,
    String value,
    String label,
    bool selected,
  ) => SimpleDialogOption(
    onPressed: () => Navigator.pop(context, value),
    child: Row(
      children: [
        Icon(
          selected ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 20,
          color: selected ? ZT.accent : ZT.textLo,
        ),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    ),
  );
}

class _BiometricTile extends ConsumerWidget {
  const _BiometricTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(biometricProvider);
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ZT.accent.withValues(alpha: 0.10),
          ),
          child: const Icon(Icons.fingerprint, color: ZT.accent),
        ),
        title: Text(
          l10n.biometricLockTitle,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          l10n.biometricLockSubtitle,
          style: const TextStyle(fontSize: 12),
        ),
        activeThumbColor: ZT.accent,
        value: enabled,
        onChanged: (value) => _toggle(context, ref, value),
      ),
    );
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref, bool value) async {
    final l10n = AppLocalizations.of(context)!;
    void toast(String msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }

    if (value) {
      final available = await BiometricService.instance.isAvailable();
      if (!available) {
        if (context.mounted) toast(l10n.biometricUnavailableToast);
        return;
      }
    }

    final bool ok;
    try {
      ok = await BiometricService.instance.authenticate(
        value ? l10n.biometricEnableReason : l10n.biometricDisableReason,
      );
    } on BiometricUnavailableException {
      if (!value) await ref.read(biometricProvider.notifier).set(false);
      if (context.mounted) {
        toast(
          value ? l10n.biometricNoLockToast : l10n.biometricForceDisabledToast,
        );
      }
      return;
    } catch (e) {
      if (context.mounted) toast(l10n.authIncompleteToast('$e'));
      return;
    }

    if (ok) {
      await ref.read(biometricProvider.notifier).set(value);
    }
  }
}

class _KeepAliveTile extends ConsumerWidget {
  const _KeepAliveTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(keepAliveEnabledProvider);
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ZT.accent.withValues(alpha: 0.10),
          ),
          child: const Icon(Icons.shield_outlined, size: 22, color: ZT.accent),
        ),
        title: Text(
          l10n.keepAliveTitle,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          enabled ? l10n.keepAliveOn : l10n.keepAliveOff,
          style: const TextStyle(fontSize: 12),
        ),
        activeThumbColor: ZT.accent,
        value: enabled,
        onChanged: (v) => ref.read(keepAliveEnabledProvider.notifier).set(v),
      ),
    );
  }
}

class _BatteryTile extends ConsumerStatefulWidget {
  const _BatteryTile();

  @override
  ConsumerState<_BatteryTile> createState() => _BatteryTileState();
}

class _BatteryTileState extends ConsumerState<_BatteryTile> {
  bool? _ignored;
  bool _blocked = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final service = KeepAliveService.instance;
    final results = await Future.wait([
      service.isBatteryIgnored,
      service.isBlocked,
    ]);
    if (mounted) {
      setState(() {
        _ignored = results[0];
        _blocked = results[1];
      });
    }
  }

  Future<void> _request() async {
    final service = KeepAliveService.instance;
    if (_blocked) {
      await service.requestVendorExemption();
    } else {
      await service.requestBatteryExemption();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(appLifecycleProvider, (prev, next) {
      if (next == AppLifecycleState.resumed) _refresh();
    });
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _blocked ? ZT.danger.withValues(alpha: 0.10) : ZT.surfaceHi,
          ),
          child: Icon(
            _blocked ? Icons.shield_moon_outlined : Icons.battery_saver,
            size: 20,
            color: _blocked ? ZT.danger : ZT.accent,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.batteryWhitelistTitle,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(switch ((_blocked, _ignored)) {
          (true, _) => AppLocalizations.of(context)!.batteryBlocked,
          (_, null) => AppLocalizations.of(context)!.batteryChecking,
          (_, false) => AppLocalizations.of(context)!.batteryNotExempt,
          (_, true) => AppLocalizations.of(context)!.batteryExempt,
        }, style: const TextStyle(fontSize: 12)),
        trailing: switch ((_blocked, _ignored)) {
          (_, null) => const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          (true, _) => const Icon(
            Icons.warning_amber_rounded,
            size: 20,
            color: ZT.danger,
          ),
          (_, true) => const Icon(
            Icons.check_circle,
            size: 20,
            color: ZT.accent,
          ),
          (_, false) => const Icon(Icons.chevron_right, color: ZT.textLo),
        },
        onTap: _blocked || _ignored != true ? _request : null,
      ),
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  const _NotificationCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationPrefsProvider);
    final notifier = ref.read(notificationPrefsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    Widget tile(
      String title,
      String subtitle,
      bool value,
      ValueChanged<bool> onChanged,
    ) => SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      activeThumbColor: ZT.accent,
      value: value,
      onChanged: onChanged,
    );

    return Card(
      child: Column(
        children: [
          tile(
            l10n.notifApprovalTitle,
            l10n.notifApprovalSubtitle,
            prefs.approval,
            (v) => notifier.set(prefs.copyWith(approval: v)),
          ),
          const Divider(indent: 16, endIndent: 16, height: 1),
          tile(
            l10n.notifCompleteTitle,
            l10n.notifCompleteSubtitle,
            prefs.complete,
            (v) => notifier.set(prefs.copyWith(complete: v)),
          ),
          const Divider(indent: 16, endIndent: 16, height: 1),
          tile(
            l10n.notifFailTitle,
            l10n.notifFailSubtitle,
            prefs.fail,
            (v) => notifier.set(prefs.copyWith(fail: v)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.notifFootnote,
                style: const TextStyle(fontSize: 11, color: ZT.textLo),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  static final _info = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: _info,
      builder: (context, snapshot) {
        final info = snapshot.data;
        if (info == null) return const SizedBox(height: 40);
        return Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Center(
            child: Text(
              'ZRemote v${info.version}',
              style: const TextStyle(
                fontSize: 11,
                letterSpacing: 1,
                color: ZT.textLo,
              ),
            ),
          ),
        );
      },
    );
  }
}
