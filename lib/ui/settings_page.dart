import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../services/biometric.dart';
import '../services/keepalive.dart';
import '../state/app_lifecycle.dart';
import '../state/notification_prefs.dart';
import '../state/keepalive.dart';
import '../state/session_pool.dart';
import '../theme.dart';
import 'section_label.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  const Text(
                    '设置',
                    style: TextStyle(
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
            const SectionLabel('安全'),
            const _BiometricTile(),
            const SizedBox(height: 12),
            const SectionLabel('后台'),
            const _KeepAliveTile(),
            const _BatteryTile(),
            const SizedBox(height: 12),
            const SectionLabel('通知'),
            const _NotificationCard(),
            const _VersionFooter(),
          ],
        ),
      ),
    );
  }
}

class _BiometricTile extends ConsumerWidget {
  const _BiometricTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(biometricProvider);
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
        title: const Text(
          '生物识别锁',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        subtitle: const Text('启动与离开较久后回到前台需验证', style: TextStyle(fontSize: 12)),
        activeThumbColor: ZT.accent,
        value: enabled,
        onChanged: (value) => _toggle(context, ref, value),
      ),
    );
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref, bool value) async {
    void toast(String msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }

    if (value) {
      final available = await BiometricService.instance.isAvailable();
      if (!available) {
        if (context.mounted) toast('此设备未配置生物识别或屏幕锁');
        return;
      }
    }

    final bool ok;
    try {
      ok = await BiometricService.instance.authenticate(
        value ? '验证以开启 ZRemote 生物识别锁' : '验证以关闭 ZRemote 生物识别锁',
      );
    } on BiometricUnavailableException {
      if (!value) await ref.read(biometricProvider.notifier).set(false);
      if (context.mounted) {
        toast(value ? '此设备无可用屏幕锁，无法开启' : '设备已无可用屏幕锁，已强制关闭防锁死');
      }
      return;
    } catch (e) {
      if (context.mounted) toast('验证未完成，开关保持原状（$e）');
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
        title: const Text(
          '后台保活',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          enabled ? '切后台仍实时接收会话事件' : '退后台可能被系统冻结',
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
            color: _blocked
                ? ZT.danger.withValues(alpha: 0.10)
                : ZT.surfaceHi,
          ),
          child: Icon(
            _blocked ? Icons.shield_moon_outlined : Icons.battery_saver,
            size: 20,
            color: _blocked ? ZT.danger : ZT.accent,
          ),
        ),
        title: const Text(
          '电池优化白名单',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          switch ((_blocked, _ignored)) {
            (true, _) => '守护被系统限制：点此去省电策略设「无限制」',
            (_, null) => '检测中…',
            (_, false) => '未豁免：点击申请（部分厂商还需允许自启动）',
            (_, true) => '已豁免——后台不受 Doze 限流',
          },
          style: const TextStyle(fontSize: 12),
        ),
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
          (_, true) => const Icon(Icons.check_circle, size: 20, color: ZT.accent),
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
            '审批请求',
            '需要你的批准或输入（推荐开启）',
            prefs.approval,
            (v) => notifier.set(prefs.copyWith(approval: v)),
          ),
          const Divider(indent: 16, endIndent: 16, height: 1),
          tile(
            '任务完成',
            '会话跑完时提醒',
            prefs.complete,
            (v) => notifier.set(prefs.copyWith(complete: v)),
          ),
          const Divider(indent: 16, endIndent: 16, height: 1),
          tile(
            '任务失败',
            '会话出错时提醒',
            prefs.fail,
            (v) => notifier.set(prefs.copyWith(fail: v)),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 6, 16, 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '提醒会标注来源设备与会话；正在查看的会话不提醒',
                style: TextStyle(fontSize: 11, color: ZT.textLo),
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
