import 'dart:convert';

abstract final class WebTheme {
  static const storageKey = 'zcode-theme';

  static String storageValue(bool dark) => dark ? 'zai-dark' : 'zai-light';

  static String seedScript(bool dark) =>
      '(function(){'
      'try{localStorage.setItem(${_q(storageKey)},${_q(storageValue(dark))})}'
      'catch(e){}'
      '})()';

  static String applyScript(bool dark) =>
      '(function(){'
      'var d=${dark ? 'true' : 'false'};'
      'try{localStorage.setItem(${_q(storageKey)},'
      '${_q(storageValue(dark))})}catch(e){}'
      'try{var el=document.documentElement;'
      'el.classList.toggle("dark",d);'
      'el.classList.toggle("theme-zai-dark",d);'
      'el.classList.toggle("theme-zai-light",!d);'
      '}catch(e){}'
      '})()';

  static String _q(String s) => jsonEncode(s);
}
