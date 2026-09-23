import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:zremote/services/web_theme.dart';

void main() {
  group('storageValue', () {
    test('始终写已解析值，永不透传 system', () {
      expect(WebTheme.storageValue(true), 'zai-dark');
      expect(WebTheme.storageValue(false), 'zai-light');
      expect(WebTheme.storageValue(true), isNot('system'));
      expect(WebTheme.storageValue(false), isNot('system'));
    });
  });

  group('seedScript', () {
    test('DOCUMENT_START 播种：storage 键值 jsonEncode 字面量 + IIFE 包裹', () {
      final s = WebTheme.seedScript(true);
      expect(
        s,
        contains(
          'localStorage.setItem(${jsonEncode(WebTheme.storageKey)},'
          '${jsonEncode('zai-dark')})',
        ),
      );
      expect(s.startsWith('(function(){'), isTrue);
      expect(s.endsWith('})()'), isTrue);
      expect(s, contains('catch'));
    });

    test('浅色播种 zai-light', () {
      expect(WebTheme.seedScript(false), contains(jsonEncode('zai-light')));
    });
  });

  group('applyScript', () {
    test('深色：d=true + 三类 toggle（dark/theme-zai-dark/theme-zai-light）', () {
      final s = WebTheme.applyScript(true);
      expect(s, contains('var d=true;'));
      expect(s, contains('el.classList.toggle("dark",d)'));
      expect(s, contains('el.classList.toggle("theme-zai-dark",d)'));
      expect(s, contains('el.classList.toggle("theme-zai-light",!d)'));
      expect(s, contains(jsonEncode('zai-dark')));
    });

    test('浅色：d=false，同一 toggle 集', () {
      final s = WebTheme.applyScript(false);
      expect(s, contains('var d=false;'));
      expect(s, contains(jsonEncode('zai-light')));
      expect(s, contains('theme-zai-light'));
    });
  });
}
