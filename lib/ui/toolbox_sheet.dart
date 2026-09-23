import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/device.dart';
import '../state/automation.dart';
import '../state/claim_entry.dart';
import '../theme.dart';
import 'sheet_shell.dart';

Future<void> showToolboxSheet({
  required BuildContext context,
  required RemoteDevice device,
  required VoidCallback onAutomationPressed,
  required VoidCallback onClaimPressed,
  required VoidCallback onUsagePressed,
}) {
  return showZrSheet<void>(
    context: context,
    builder: (sheetContext) => ToolboxSheet(
      device: device,
      onAutomationPressed: onAutomationPressed,
      onClaimPressed: onClaimPressed,
      onUsagePressed: onUsagePressed,
    ),
  );
}

class ToolboxSheet extends ConsumerWidget {
  const ToolboxSheet({
    super.key,
    required this.device,
    required this.onAutomationPressed,
    required this.onClaimPressed,
    required this.onUsagePressed,
  });

  final RemoteDevice device;
  final VoidCallback onAutomationPressed;
  final VoidCallback onClaimPressed;
  final VoidCallback onUsagePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zt = context.zt;
    final l10n = AppLocalizations.of(context)!;
    final autoBoard = ref.watch(automationProvider)[device.id];
    final claimReady = ref.watch(claimEntryProvider)[device.id] == true;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: zt.accentSubtle,
                ),
                child: Icon(
                  Icons.dashboard_customize_outlined,
                  size: 17,
                  color: zt.accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.toolboxTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: zt.textHi,
                  ),
                ),
              ),
              _SheetCloseButton(
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: zt.hairline),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _ToolGridCard(
                      icon: Icons.auto_mode_rounded,
                      title: l10n.toolboxAutomation,
                      subtitle: l10n.toolboxAutomationDesc,
                      badgeText: (autoBoard?.queuedCount ?? 0) > 0
                          ? l10n.toolboxQueued(autoBoard!.queuedCount)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        onAutomationPressed();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ToolGridCard(
                      icon: Icons.card_giftcard_rounded,
                      title: l10n.toolboxClaim,
                      subtitle: l10n.toolboxClaimDesc,
                      enabled: claimReady,
                      badgeText: claimReady ? l10n.toolboxClaimReady : null,
                      badgeColor: zt.live,
                      onTap: () {
                        Navigator.pop(context);
                        onClaimPressed();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ToolGridCard(
                      icon: Icons.query_stats_rounded,
                      title: l10n.toolboxUsage,
                      subtitle: l10n.toolboxUsageDesc,
                      onTap: () {
                        Navigator.pop(context);
                        onUsagePressed();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _ToolPlaceholderCard(
                title: l10n.toolboxMoreComing,
                subtitle: l10n.toolboxMoreComingDesc,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToolGridCard extends StatelessWidget {
  const _ToolGridCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
    this.badgeText,
    this.badgeColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool enabled;
  final String? badgeText;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: enabled ? 1.0 : 0.45,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? (enabled
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.white.withValues(alpha: 0.015))
                  : (enabled
                      ? zt.surface
                      : zt.field.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark
                    ? (enabled
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.white.withValues(alpha: 0.04))
                    : (enabled
                        ? zt.hairline
                        : zt.hairline.withValues(alpha: 0.5)),
                width: 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: enabled
                            ? zt.accentSubtle
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.04)
                                : Colors.black.withValues(alpha: 0.03)),
                      ),
                      child: Icon(
                        icon,
                        size: 18,
                        color: enabled ? zt.accent : zt.textTertiary,
                      ),
                    ),
                    const Spacer(),
                    if (badgeText != null)
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: (badgeColor ??
                                    (enabled ? zt.accent : zt.textTertiary))
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: (badgeColor ??
                                      (enabled ? zt.accent : zt.textTertiary))
                                  .withValues(alpha: 0.4),
                              width: 0.6,
                            ),
                          ),
                          child: Text(
                            badgeText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: badgeColor ??
                                  (enabled ? zt.accent : zt.textTertiary),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: enabled ? zt.textHi : zt.textLo,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.25,
                    color: enabled ? zt.textLo : zt.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolPlaceholderCard extends StatelessWidget {
  const _ToolPlaceholderCard({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final zt = context.zt;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.02)
            : zt.field.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : zt.hairline.withValues(alpha: 0.6),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.03),
            ),
            child: Icon(
              Icons.widgets_outlined,
              size: 16,
              color: zt.textTertiary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: zt.textLo,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: zt.textTertiary,
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

class _SheetCloseButton extends StatelessWidget {
  const _SheetCloseButton({required this.onTap});

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
