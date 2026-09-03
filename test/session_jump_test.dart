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

    test('workspace 名同样只以 jsonEncode 字面量出现；缺省为 null 字面量', () {
      final script = SessionJump.jumpScript('abc', workspace: 'my proj');
      expect(script.contains('var ws = ${jsonEncode('my proj')};'), isTrue);
      final bare = SessionJump.jumpScript('abc');
      expect(bare.contains('var ws = null;'), isTrue);
    });

    test('恶意输入防注入：payload 只以 jsonEncode 字面量出现', () {
      const evil = "'); alert(1; ('";
      final script = SessionJump.jumpScript(evil);
      final encoded = jsonEncode(evil);
      expect(script.contains('var tid = $encoded'), isTrue);
      expect(jsonDecode(encoded), evil);
    });

    test('走「全取 + JS 过滤」，不做 CSS 选择器拼接；含滚动与点击', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.contains("querySelectorAll('[data-testid]')"), isTrue);
      expect(script.contains('scrollIntoView'), isTrue);
      expect(script.contains('.click()'), isTrue);
    });

    test('v3：点击前 isConnected 复验（流式重渲染可能换节点）', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.contains('.isConnected) continue;'), isTrue);
      final connCheck = script.indexOf('.isConnected');
      final firstClick = script.indexOf('.click()');
      expect(connCheck, lessThan(firstClick));
    });

    test('v2：find 落空时点「返回任务首页」回列表重找（aria-label 把手）', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.contains('aria-label="返回任务首页"'), isTrue);
      expect(script.contains('aria-label*="返回"'), isTrue);
    });

    test('v2：英文环境把手「Back to task home」一并覆盖（bundle i18n）', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.contains('aria-label="Back to task home"'), isTrue);
      expect(script.contains('aria-label^="Back to"'), isTrue);
    });

    test('v3：折叠组头结构性把手（aria-expanded）+ workspace 名匹配', () {
      final script = SessionJump.jumpScript('abc', workspace: 'ZRemote');
      expect(
        script.contains("querySelectorAll('button[aria-expanded="),
        isTrue,
      );
      expect(
        script.contains('a.indexOf(b) !== -1 || b.indexOf(a) !== -1'),
        isTrue,
      );
      expect(script.contains('toLowerCase()'), isTrue);
    });

    test('v3：标签漂移兜底=逐组试探且未命中复原（用户折叠布局零破坏）', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.contains('mine.add(heads[i]);'), isTrue);
      expect(script.contains('mine.delete(heads[i]);'), isTrue);
      expect(script.contains('tried.has(heads[i])) continue;'), isTrue);
    });

    test('v3：MutationObserver 事件驱动 + interval 兜底 + 20s 预算自净', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.contains('new MutationObserver(schedule)'), isTrue);
      expect(script.contains("attributeFilter: ['aria-expanded']"), isTrue);
      expect(script.contains('setInterval(tick, 400)'), isTrue);
      expect(script.contains('Date.now() + 20000'), isTrue);
      expect(script.contains('mo.disconnect();'), isTrue);
      expect(script.contains('clearInterval(iv);'), isTrue);
    });

    test('v3：代际守卫——连点两跳最新者胜，旧 watch 自净', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.contains("__zrJumpGen"), isTrue);
      expect(script.contains('window[GEN] !== myGen'), isTrue);
      final staleCheck = script.indexOf('if (stale())');
      final findAction = script.indexOf('if (find()) { stop(); return; }');
      expect(staleCheck, lessThan(findAction));
      expect(staleCheck, lessThan(script.indexOf('Date.now() > deadline')));
    });

    test('v3：fuzzy 返回按钮误配防饿死——已点击仍存留 5 tick 后放行', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.contains('backTries'), isTrue);
      expect(script.contains('backTries <= 5) return;'), isTrue);
    });

    test('v3：stale / 超时退出前统一复原试探组（收尾不漏展开）', () {
      final script = SessionJump.jumpScript('abc');
      expect('for (; restoreProbe(); ) {}'.allMatches(script).length, 2);
    });

    test('v3：tick 策略顺序——匹配展开 → 复原 → 试探（一次一组不变式）', () {
      final script = SessionJump.jumpScript('abc');
      final expand = script.indexOf('if (expandTarget()) return;');
      final restore = script.indexOf('if (restoreProbe()) return;');
      final probe = script.indexOf('    probeExpand();');
      expect(expand, isNot(-1));
      expect(restore, isNot(-1));
      expect(probe, isNot(-1));
      expect(expand, lessThan(restore));
      expect(restore, lessThan(probe));
    });

    test('v3：workspace 缺省短路——ws=null 时 matchWs 恒 false 直走试探', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.contains('if (!ws || !label) return false;'), isTrue);
    });

    test('v2 升级仅在 find() 落空后发生（先找退按钮后查询，不打断直跳）', () {
      final script = SessionJump.jumpScript('abc');
      final earlyReturn = script.indexOf('if (find()) return true;');
      final backQueryCall = script.indexOf('var back = findBack();');
      expect(earlyReturn, isNot(-1));
      expect(backQueryCall, isNot(-1));
      expect(earlyReturn, lessThan(backQueryCall));
    });

    test('v3：异步引擎启动后返回 async（慢渲染等待语义替代 v2 的 false）', () {
      final script = SessionJump.jumpScript('abc');
      expect(script.contains("return 'async';"), isTrue);
      expect(script.contains('if (!tid) return false;'), isTrue);
    });
  });
}
