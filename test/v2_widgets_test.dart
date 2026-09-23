import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/state/session_status.dart';
import 'package:zremote/theme.dart';
import 'package:zremote/ui/bevel_card.dart';
import 'package:zremote/ui/hw_chip.dart';
import 'package:zremote/ui/sheet_shell.dart';
import 'package:zremote/ui/status_led.dart';
import 'package:zremote/ui/tactile_button.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: ZT.theme(Brightness.dark),
    home: Scaffold(body: child),
  );

  testWidgets('BevelCard：泵出 child 文本不抛', (tester) async {
    await tester.pumpWidget(
      wrap(const BevelCard(child: Text('bevel-content'))),
    );
    expect(find.text('bevel-content'), findsOneWidget);
  });

  testWidgets('HwChip：等宽字族 + 表格数字排印', (tester) async {
    await tester.pumpWidget(wrap(const HwChip(text: 'X1-42')));
    final style = tester.widget<Text>(find.text('X1-42')).style!;
    expect(style.fontFamily, kMonoFamily);
    expect(style.fontFeatures, contains(FontFeature.tabularFigures()));
  });

  testWidgets('TactileButton：三 variant 构建 + tap 触发回调', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrap(
        Column(
          children: [
            TactileButton(label: '普通键', onPressed: () => taps++),
            TactileButton(
              label: '主操作键',
              variant: TactileVariant.primary,
              onPressed: () => taps++,
            ),
            TactileButton(
              label: '危险键',
              variant: TactileVariant.danger,
              onPressed: () => taps++,
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.text('普通键'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('主操作键'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('危险键'));
    await tester.pumpAndSettle();
    expect(taps, 3);
  });

  testWidgets('showZrSheet：弹出面板含拖拽把手', (tester) async {
    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (context) => Center(
            child: TactileButton(
              label: '打开弹层',
              onPressed: () => showZrSheet(
                context: context,
                builder: (_) => const Text('sheet-body'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('打开弹层'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('zr-sheet-handle')), findsOneWidget);
    expect(find.text('sheet-body'), findsOneWidget);
  });

  testWidgets('StatusLed：live 泵出不抛 + Semantics 标签透传', (tester) async {
    await tester.pumpWidget(
      wrap(
        const StatusLed(
          status: SessionStatus.live,
          semanticLabel: '设备在线',
        ),
      ),
    );
    expect(find.bySemanticsLabel('设备在线'), findsOneWidget);
  });
}
