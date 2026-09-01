import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/services/session_jump.dart';

void main() {
  group('SessionJump.jumpScript', () {
    test('输出是 IIFE 表达式（evaluateJavascript 需要表达式）', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.startsWith('(function('), isTrue);
      expect(script.endsWith('})()'), isTrue);
    });

    test('普通 taskId 以 JSON 字符串字面量出现', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.contains(jsonEncode('abc')), isTrue);
    });

    test('含双引号的 taskId 被 jsonEncode 转义，无裸字面量', () {
      final script = SessionJump.jumpScript('a"b');
      expect(script.contains(jsonEncode('a"b')), isTrue);
      expect(script.contains('a"b'), isFalse);
    });

    test('走「全取 + JS 过滤」，不做 CSS 选择器拼接；含滚动与点击', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.contains("querySelectorAll('[data-testid]')"), isTrue);
      expect(script.contains('scrollIntoView'), isTrue);
      expect(script.contains('.click()'), isTrue);
    });

    test('恶意输入防注入：payload 只以 jsonEncode 字面量出现', () {
      const evil = "'); alert(1; ('";
      final script = SessionJump.jumpScript(evil);
      final encoded = jsonEncode(evil);
      expect(script.contains('var tid = $encoded'), isTrue);
      expect(jsonDecode(encoded), evil);
    });

    test('v2：find 落空时点「返回任务首页」回列表并轮询重找，返回 async', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.contains('aria-label="返回任务首页"'), isTrue);
      expect(script.contains('aria-label*="返回"'), isTrue);
      expect(script.contains('setInterval'), isTrue);
      expect(script.contains("return 'async';"), isTrue);
    });

    test('v2：英文环境把手「Back to task home」一并覆盖（bundle i18n）', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.contains('aria-label="Back to task home"'), isTrue);
      expect(script.contains('aria-label^="Back to"'), isTrue);
    });

    test('v2 升级仅在 find() 落空后发生（先找后退，不打断列表态直跳）', () {
      final script = SessionJump.jumpScript('abc');
      final earlyReturn = script.indexOf('if (find()) return true;');
      final backQuery = script.indexOf('aria-label');
      expect(earlyReturn, isNot(-1));
      expect(backQuery, isNot(-1));
      expect(earlyReturn, lessThan(backQuery));
    });
  });
}
