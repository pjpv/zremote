import 'dart:convert';

abstract final class SessionJump {
  static String jumpScript(String taskId) {
    final literal = jsonEncode(taskId);
    return '''
(function() {
  var tid = $literal;
  if (!tid) return false;
  var find = function() {
    var els = document.querySelectorAll('[data-testid]');
    for (var i = 0; i < els.length; i++) {
      var t = els[i].getAttribute('data-testid') || '';
      if (t.indexOf(tid) === -1) continue;
      if (els[i].getClientRects().length === 0) continue;
      els[i].scrollIntoView({block: 'center'});
      els[i].click();
      return true;
    }
    return false;
  };
  if (find()) return true;
  var backSel = [
    'button[aria-label="返回任务首页"]',
    'button[aria-label="Back to task home"]',
    'button[aria-label*="返回"]',
    'button[aria-label^="Back to"]'
  ];
  var back = null;
  for (var s = 0; s < backSel.length; s++) {
    back = document.querySelector(backSel[s]);
    if (back) break;
  }
  if (!back) return false;
  back.click();
  var tries = 0;
  var iv = setInterval(function() {
    tries++;
    if (find() || tries > 25) clearInterval(iv);
  }, 120);
  return 'async';
})()''';
  }
}
