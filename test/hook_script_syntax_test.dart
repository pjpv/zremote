import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/services/event_observer.dart';

void main() {
  final script = EventObserver.hookScriptFor(47832, 'ab12cd34');

  test('写路径关键标识符存在', () {
    expect(script.contains('window.__zrSvcCall'), isTrue);
    expect(script.contains('zrSvcResult'), isTrue);
    expect(script.contains('zrFindServices'), isTrue);
    expect(script.contains('zcodeAgentService'), isTrue);
    expect(script.contains('offPeakTaskService'), isTrue);
    expect(script.contains('window.__zrRpcCall'), isFalse);
    expect(script.contains('zrPollStart'), isTrue);
    expect(
      script.contains("'http://127.0.0.1:' + 47832 + '/zrp/' + 'ab12cd34'"),
      isTrue,
    );
    expect(script.contains('zrSeen[id]'), isTrue);
    expect(script.contains('__zrProbe'), isTrue);
    expect(script.contains('zrProbeRun'), isTrue);
    expect(script.contains("method !== 'dump'"), isTrue);
  });

  test('JS 体内零 // 序列（:// 除外）', () {
    for (
      var i = script.indexOf('//');
      i >= 0;
      i = script.indexOf('//', i + 1)
    ) {
      expect(
        i > 0 && script[i - 1] == ':',
        isTrue,
        reason:
            'hookScript 内出现裸 //（offset $i）：'
            '...${script.substring(i < 20 ? 0 : i - 20, i + 20)}...',
      );
    }
  });

  test('无块注释起始符号', () {
    expect(script.contains('/' '*'), isFalse);
  });

  test('字符串感知的括号配平（引号必须全部闭合）', () {
    var brace = 0, paren = 0, bracket = 0;
    var inSingle = false, inDouble = false;
    for (var i = 0; i < script.length; i++) {
      final c = script[i];
      if (inSingle || inDouble) {
        if (c == r'\') {
          i++;
          continue;
        }
        if (inSingle && c == "'") inSingle = false;
        if (inDouble && c == '"') inDouble = false;
        continue;
      }
      if (c == "'") {
        inSingle = true;
      } else if (c == '"') {
        inDouble = true;
      } else if (c == '{') {
        brace++;
      } else if (c == '}') {
        brace--;
      } else if (c == '(') {
        paren++;
      } else if (c == ')') {
        paren--;
      } else if (c == '[') {
        bracket++;
      } else if (c == ']') {
        bracket--;
      }
    }
    expect(inSingle, isFalse, reason: '存在未闭合的单引号字符串');
    expect(inDouble, isFalse, reason: '存在未闭合的双引号字符串');
    expect(brace, 0, reason: '花括号不配平');
    expect(paren, 0, reason: '圆括号不配平');
    expect(bracket, 0, reason: '方括号不配平');
  });
}
