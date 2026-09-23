import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/l10n/app_localizations.dart';
import 'package:zremote/services/event_observer.dart';
import 'package:zremote/state/session_index.dart';
import 'package:zremote/theme.dart';
import 'package:zremote/ui/session_panel.dart';

void main() {
  final bgFile = File(r'J:\tmp\zremote\build\screenshots\session_view_bg.jpg');
  final hasBg = bgFile.existsSync();
  final bgImage = FileImage(bgFile);

  Future<void> precacheRealImage() {
    if (!hasBg) return Future.value();
    final c = Completer<void>();
    final stream = bgImage.resolve(const ImageConfiguration());
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (_, _) {
        scheduleMicrotask(() {
          if (!c.isCompleted) c.complete();
        });
      },
      onChunk: (_) {},
      onError: (_, _) {
        if (!c.isCompleted) c.completeError('背景图解码失败');
      },
    );
    stream.addListener(listener);
    return c.future;
  }
  setUpAll(() async {
    const candidates = [
      r'C:\Windows\Fonts\msyh.ttc',
      r'C:\Windows\Fonts\simhei.ttf',
    ];
    final path = candidates.firstWhere(
      (p) => File(p).existsSync(),
      orElse: () => candidates.last,
    );
    final loader = FontLoader('ShotFont')
      ..addFont(Future.value(
        ByteData.view(
          File(path).readAsBytesSync().buffer.asUint8List().buffer,
        ),
      ));
    await loader.load();
    final mono = FontLoader(kMonoFamily)
      ..addFont(Future.value(
        ByteData.view(
          File('assets/fonts/JetBrainsMono-Regular.ttf')
              .readAsBytesSync()
              .buffer
              .asUint8List()
              .buffer,
        ),
      ));
    await mono.load();
  });

  final now = DateTime(2026, 9, 1, 20, 30);
  int at(int month, int d, int h, int m) =>
      DateTime(2026, month, d, h, m).millisecondsSinceEpoch;

  final sessions = <SessionState>[
    SessionState(
      sessionId: 'sess_pin_deploy',
      title: '部署发布流水线',
      phase: 'running',
      workspace: 'zremote',
      permissionCount: 2,
      userInputCount: 1,
      lastActivityAt: now.millisecondsSinceEpoch - 2 * 60 * 1000,
      createdAt: now.millisecondsSinceEpoch - 3 * 3600 * 1000,
    ),
    SessionState(
      sessionId: 'sess_login_dark',
      title: '修复登录页在深色模式下的样式',
      phase: 'running',
      workspace: 'homepage-v3',
      lastActivityAt: now.millisecondsSinceEpoch - 30 * 1000,
      createdAt: now.millisecondsSinceEpoch - 40 * 60 * 1000,
    ),
    SessionState(
      sessionId: 'sess_pay_cb',
      title: '接口联调：支付回调签名校验',
      phase: 'running',
      workspace: 'invoice-bot',
      permissionCount: 1,
      lastActivityAt: now.millisecondsSinceEpoch - 12 * 60 * 1000,
      createdAt: now.millisecondsSinceEpoch - 2 * 3600 * 1000,
    ),
    SessionState(
      sessionId: 'sess_crawl',
      title: '爬虫脚本调试：目标站反爬升级',
      phase: 'error',
      workspace: 'data-pipeline',
      lastActivityAt: now.millisecondsSinceEpoch - 95 * 60 * 1000,
      createdAt: now.millisecondsSinceEpoch - 3 * 3600 * 1000,
    ),
    SessionState(
      sessionId: 'sess_notify_refactor',
      title: '重构通知模块补齐单测',
      phase: 'completedSuccess',
      workspace: 'zremote',
      lastActivityAt: now.millisecondsSinceEpoch - 5 * 3600 * 1000,
      createdAt: now.millisecondsSinceEpoch - 8 * 3600 * 1000,
    ),
    SessionState(
      sessionId: 'sess_weekly',
      title: '周报数据抓取',
      phase: 'completedInterrupted',
      workspace: 'report-bot',
      lastActivityAt: now.millisecondsSinceEpoch - 8 * 3600 * 1000,
      createdAt: DateTime(2026, 9, 1, 8, 0).millisecondsSinceEpoch,
    ),
    SessionState(
      sessionId: 'sess_db_migrate',
      title: '数据库迁移脚本预演',
      phase: 'running',
      workspace: 'ledger-api',
      userInputCount: 2,
      lastActivityAt: at(8, 31, 18, 5),
      createdAt: at(8, 31, 10, 0),
    ),
    SessionState(
      sessionId: 'sess_portal',
      title: '客户门户 v2 原型',
      phase: 'completedSuccess',
      workspace: 'portal-v2',
      lastActivityAt: at(8, 31, 9, 40),
      createdAt: at(8, 31, 9, 0),
    ),
    SessionState(
      sessionId: 'sess_dep_upgrade',
      title: '遗留依赖升级（Android 36 适配）',
      phase: 'completedSuccess',
      workspace: 'zremote',
      lastActivityAt: at(8, 30, 14, 0),
      createdAt: at(8, 30, 11, 0),
    ),
  ]..sort(SessionRanking.compareSessions);

  for (final (tag, locale) in [('zh', const Locale('zh')), ('en', const Locale('en'))]) {
    testWidgets('会话面板截图 $tag', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.runAsync(precacheRealImage);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'ShotFont',
            scaffoldBackgroundColor: ZT.dark.bg,
          ),
          home: Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                if (hasBg) ...[
                  Image(
                    image: bgImage,
                    fit: BoxFit.cover,
                  ),
                  Container(color: Colors.black26),
                ],
                if (!hasBg) ColoredBox(color: ZT.dark.bg),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 506),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(26),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [ZT.dark.surfaceHi, ZT.dark.surface],
                          ),
                          border: Border(
                            top: BorderSide(color: ZT.dark.hairlineBright),
                            left: BorderSide(color: ZT.dark.hairline),
                            right: BorderSide(color: ZT.dark.hairline),
                            bottom: BorderSide(color: ZT.dark.hairline),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 36,
                              height: 4,
                              margin: const EdgeInsets.only(top: 10, bottom: 4),
                              decoration: BoxDecoration(
                                color: ZT.dark.hairlineBright,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Flexible(
                              child: SessionPanelSheet(
                                sessions: sessions,
                                activeSessionId: 'sess_pin_deploy',
                                now: now,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/session_panel_$tag.png'),
      );
    });
  }
}
