import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/l10n/app_localizations.dart';
import 'package:zremote/ui/schedule_dial.dart';

void main() {
  Future<void> pumpDial(
    WidgetTester tester, {
    required List<DialEntry> entries,
    required DateTime now,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(child: ScheduleDial(entries: entries, now: now)),
        ),
      ),
    );
  }

  testWidgets('有排程：表盘渲染 + 图例逐任务一条', (tester) async {
    await pumpDial(
      tester,
      entries: const [
        DialEntry(
          time: null,
          color: Color(0xFF3B82F6),
          label: '每天 02:00',
        ),
        DialEntry(
          time: null,
          color: Color(0xFF10B981),
          label: '每周日 02:00',
        ),
      ],
      now: DateTime(2026, 9, 13, 14, 30),
    );
    expect(find.byType(ScheduleDial), findsOneWidget);
    expect(find.text('每天 02:00'), findsOneWidget);
    expect(find.text('每周日 02:00'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('time 为 null 的条目只进图例不落点（painter 由 golden/目检覆盖）',
      (tester) async {
    await pumpDial(
      tester,
      entries: const [
        DialEntry(time: null, color: Color(0xFF3B82F6), label: '每天 02:00'),
      ],
      now: DateTime(2026, 9, 13, 14, 30),
    );
    expect(find.text('每天 02:00'), findsOneWidget);
  });

  testWidgets('空条目不渲染任何东西', (tester) async {
    await pumpDial(tester, entries: const [], now: DateTime(2026, 9, 13, 14, 30));
    expect(find.byType(ScheduleDial), findsOneWidget);
    expect(find.text('00:00'), findsNothing);
    expect(find.textContaining('每天'), findsNothing);
  });
}
