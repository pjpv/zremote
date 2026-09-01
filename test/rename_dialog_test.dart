import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/l10n/app_localizations.dart';
import 'package:zremote/models/device.dart';
import 'package:zremote/state/keepalive.dart';
import 'package:zremote/state/session_pool.dart';
import 'package:zremote/ui/manage_page.dart';

class _FakeDeviceListNotifier extends DeviceListNotifier {
  _FakeDeviceListNotifier(this.initial);

  final List<RemoteDevice> initial;

  @override
  List<RemoteDevice> build() => initial;

  @override
  Future<void> rename(String id, String label) async {
    state = [
      for (final d in state)
        if (d.id == id) d.copyWith(label: label.trim()) else d,
    ];
  }
}

class _FakeKeepAliveNotifier extends KeepAliveEnabledNotifier {
  @override
  bool build() => false;
}

RemoteDevice _device(String sid) => RemoteDevice(
      id: 'id-$sid',
      baseUrl: 'https://zcode.z.ai/remote/v4',
      params: {'sid': sid, 'hash': 'h'},
      label: '设备$sid',
      createdAt: DateTime(2026, 1, 1),
    );

Future<void> _pumpManage(WidgetTester tester, List<RemoteDevice> devices) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        deviceListProvider.overrideWith(() => _FakeDeviceListNotifier(devices)),
        keepAliveEnabledProvider.overrideWith(() => _FakeKeepAliveNotifier()),
      ],
      child: MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ManagePage(),
      ),
    ),
  );
}

Future<void> _openRename(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.more_horiz));
  await tester.pumpAndSettle();
  await tester.tap(find.text('重命名'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('改名保存：退场动画期间不炸元素树，名字生效', (tester) async {
    await _pumpManage(tester, [_device('ren831')]);
    await tester.pumpAndSettle();

    await _openRename(tester);
    await tester.enterText(find.byType(TextField), '新名字');
    await tester.tap(find.text('保存'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(TextField), findsNothing);
    expect(find.text('新名字'), findsOneWidget);
  });

  testWidgets('改名取消：退场动画期间不炸元素树，名字不变', (tester) async {
    await _pumpManage(tester, [_device('ren831')]);
    await tester.pumpAndSettle();

    await _openRename(tester);
    await tester.tap(find.text('取消'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(TextField), findsNothing);
    expect(find.text('设备ren831'), findsOneWidget);
  });
}
