import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../services/biometric.dart';
import '../services/keepalive.dart';
import '../state/app_lifecycle.dart';
import '../state/locale.dart';
import '../state/notification_prefs.dart';
import '../state/keepalive.dart';
import '../state/session_pool.dart';
import '../state/theme_mode.dart';
import '../theme.dart';
import 'section_label.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.zt.textLo),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Text(
          l10n.settingsTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: context.zt.textHi,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          children: [
            SectionLabel(l10n.sectionAppearance),
            const _CardGroup(
              children: [_LanguageTile(), _GroupDivider(), _ThemeTile()],
            ),
            const SizedBox(height: 16),
            SectionLabel(l10n.sectionSecurityKeepalive),
            const _CardGroup(
              children: [
                _BiometricTile(),
                _GroupDivider(),
                _KeepAliveTile(),
                _GroupDivider(),
                _BatteryTile(),
              ],
            ),
            const SizedBox(height: 16),
            SectionLabel(l10n.sectionNotifications),
            const _NotificationCard(),
            const _VersionFooter(),
          ],
        ),
      ),
    );
  }
}

class _CardGroup extends StatelessWidget {
  const _CardGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.zt.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.zt.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _GroupDivider extends StatelessWidget {
  const _GroupDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      color: context.zt.hairline,
    );
  }
}

class _TileRow extends StatelessWidget {
  const _TileRow({
    required this.title,
    required this.subtitle,
    this.icon,
    this.iconColor,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (iconColor ?? zt.accent).withValues(alpha: 0.10),
                ),
                child: Icon(icon, size: 17, color: iconColor ?? zt.accent),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: zt.textHi,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11.5, height: 1.4, color: zt.textLo),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing!,
            ],
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
    return _TileRow(
      title: l10n.languageTitle,
      subtitle: current,
      icon: Icons.language,
      trailing: Icon(Icons.chevron_right, color: context.zt.textLo),
      onTap: () => _pick(context, ref),
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
          color: selected ? context.zt.accent : context.zt.textLo,
        ),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    ),
  );
}

class _ThemeTile extends ConsumerWidget {
  const _ThemeTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final setting = ref.watch(themeModeSettingProvider);
    final current = switch (setting) {
      kThemeDark => l10n.themeDark,
      kThemeLight => l10n.themeLight,
      _ => l10n.themeSystem,
    };
    return _TileRow(
      title: l10n.themeTitle,
      subtitle: current,
      icon: Icons.contrast,
      trailing: Icon(Icons.chevron_right, color: context.zt.textLo),
      onTap: () => _pick(context, ref),
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final setting = ref.read(themeModeSettingProvider);
    final choice = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(l10n.themeTitle),
        children: [
          _option(
            dialogContext,
            kThemeSystem,
            l10n.themeSystem,
            setting == kThemeSystem,
          ),
          _option(
            dialogContext,
            kThemeDark,
            l10n.themeDark,
            setting == kThemeDark,
          ),
          _option(
            dialogContext,
            kThemeLight,
            l10n.themeLight,
            setting == kThemeLight,
          ),
        ],
      ),
    );
    if (choice == null || choice == setting) return;
    await ref.read(themeModeSettingProvider.notifier).set(choice);
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
          color: selected ? context.zt.accent : context.zt.textLo,
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
    return _TileRow(
      title: l10n.biometricLockTitle,
      subtitle: l10n.biometricLockSubtitle,
      icon: Icons.fingerprint,
      trailing: Switch(
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
    return _TileRow(
      title: l10n.keepAliveTitle,
      subtitle: enabled ? l10n.keepAliveOn : l10n.keepAliveOff,
      icon: Icons.shield_outlined,
      trailing: Switch(
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
    ref.listen(keepAliveEnabledProvider, (_, _) => _refresh());
    final l10n = AppLocalizations.of(context)!;
    return _TileRow(
      title: l10n.batteryWhitelistTitle,
      subtitle: switch ((_blocked, _ignored)) {
        (true, _) => l10n.batteryBlocked,
        (_, null) => l10n.batteryChecking,
        (_, false) => l10n.batteryNotExempt,
        (_, true) => l10n.batteryExempt,
      },
      icon: _blocked ? Icons.shield_moon_outlined : Icons.battery_saver,
      iconColor: _blocked ? context.zt.danger : context.zt.accent,
      trailing: switch ((_blocked, _ignored)) {
        (_, null) => const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        (true, _) => Icon(
          Icons.warning_amber_rounded,
          size: 20,
          color: context.zt.danger,
        ),
        (_, true) => Text(
          l10n.settingsExemptBadge,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.zt.live,
          ),
        ),
        (_, false) => Icon(Icons.chevron_right, color: context.zt.textLo),
      },
      onTap: _blocked || _ignored != true ? _request : null,
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
    ) => _TileRow(
      title: title,
      subtitle: subtitle,
      trailing: Switch(value: value, onChanged: onChanged),
    );

    return _CardGroup(
      children: [
        tile(
          l10n.notifApprovalTitle,
          l10n.notifApprovalSubtitle,
          prefs.approval,
          (v) => notifier.set(prefs.copyWith(approval: v)),
        ),
        const _GroupDivider(),
        tile(
          l10n.notifCompleteTitle,
          l10n.notifCompleteSubtitle,
          prefs.complete,
          (v) => notifier.set(prefs.copyWith(complete: v)),
        ),
        const _GroupDivider(),
        tile(
          l10n.notifFailTitle,
          l10n.notifFailSubtitle,
          prefs.fail,
          (v) => notifier.set(prefs.copyWith(fail: v)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.notifFootnote,
              style: TextStyle(
                fontSize: 11,
                color: context.zt.textTertiary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  static final _info = PackageInfo.fromPlatform();
  static const _repoUrl = 'https://github.com/pjpv/zremote';

  Future<void> _openRepo() async {
    try {
      await launchUrl(
        Uri.parse(_repoUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: _info,
      builder: (context, snapshot) {
        final info = snapshot.data;
        if (info == null) return const SizedBox(height: 40);
        return Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'ZRemote',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: context.zt.textHi,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'v${info.version}',
                      style: zrMono(
                        fontSize: 11,
                        weight: FontWeight.w400,
                        letterSpacing: 0.4,
                        color: context.zt.textLo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _openRepo,
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_outlined,
                          size: 13,
                          color: context.zt.accent,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${AppLocalizations.of(context)!.repoPrefix}: github.com/pjpv/zremote',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                            color: context.zt.accent,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.open_in_new_outlined,
                          size: 12,
                          color: context.zt.accent,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
