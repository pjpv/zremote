import 'dart:convert';

abstract final class SessionJump {
  static String jumpScript(String taskId, {String? workspace}) {
    final tidLiteral = jsonEncode(taskId);
    final wsLiteral = workspace == null ? 'null' : jsonEncode(workspace);
    return '''
(function() {
  var tid = $tidLiteral;
  var ws = $wsLiteral;
  if (!tid) return false;
  var GEN = '__zrJumpGen';
  var myGen = (window[GEN] = (window[GEN] || 0) + 1);
  var stale = function() { return window[GEN] !== myGen; };
  var deadline = Date.now() + 20000;
  var clicked = new WeakSet();
  var tried = new WeakSet();
  var mine = new WeakSet();
  var backTries = 0;
  var find = function() {
    var els = document.querySelectorAll('[data-testid]');
    for (var i = 0; i < els.length; i++) {
      var t = els[i].getAttribute('data-testid') || '';
      if (t.indexOf(tid) === -1) continue;
      if (els[i].getClientRects().length === 0) continue;
      if (!els[i].isConnected) continue;
      els[i].scrollIntoView({block: 'center'});
      els[i].click();
      return true;
    }
    return false;
  };
  var matchWs = function(label) {
    if (!ws || !label) return false;
    var a = label.toLowerCase();
    var b = ws.toLowerCase();
    return a.indexOf(b) !== -1 || b.indexOf(a) !== -1;
  };
  var backSel = [
    'button[aria-label="返回任务首页"]',
    'button[aria-label="Back to task home"]',
    'button[aria-label*="返回"]',
    'button[aria-label^="Back to"]'
  ];
  var findBack = function() {
    for (var s = 0; s < backSel.length; s++) {
      var b = document.querySelector(backSel[s]);
      if (b) return b;
    }
    return null;
  };
  var expandTarget = function() {
    var heads = document.querySelectorAll('button[aria-expanded="false"]');
    for (var i = 0; i < heads.length; i++) {
      if (tried.has(heads[i])) continue;
      if (!matchWs(heads[i].textContent || '')) continue;
      tried.add(heads[i]);
      heads[i].click();
      return true;
    }
    return false;
  };
  var restoreProbe = function() {
    var heads = document.querySelectorAll('button[aria-expanded="true"]');
    for (var i = 0; i < heads.length; i++) {
      if (!mine.has(heads[i])) continue;
      mine.delete(heads[i]);
      heads[i].click();
      return true;
    }
    return false;
  };
  var probeExpand = function() {
    var heads = document.querySelectorAll('button[aria-expanded="false"]');
    for (var i = 0; i < heads.length; i++) {
      if (tried.has(heads[i])) continue;
      tried.add(heads[i]);
      mine.add(heads[i]);
      heads[i].click();
      return true;
    }
    return false;
  };
  if (find()) return true;
  var iv = null, mo = null, deb = null;
  var stop = function() {
    if (iv) clearInterval(iv);
    if (mo) mo.disconnect();
    if (deb) clearTimeout(deb);
    iv = null; mo = null; deb = null;
  };
  var tick = function() {
    if (stale()) { for (; restoreProbe(); ) {} stop(); return; }
    if (find()) { stop(); return; }
    if (Date.now() > deadline) { for (; restoreProbe(); ) {} stop(); return; }
    var back = findBack();
    if (back) {
      if (!clicked.has(back)) { clicked.add(back); back.click(); backTries = 1; return; }
      backTries++;
      if (backTries <= 5) return;
    }
    if (expandTarget()) return;
    if (restoreProbe()) return;
    probeExpand();
  };
  var schedule = function() {
    if (deb || stale()) return;
    deb = setTimeout(function() { deb = null; tick(); }, 120);
  };
  iv = setInterval(tick, 400);
  if (document.body) {
    mo = new MutationObserver(schedule);
    mo.observe(document.body, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: ['aria-expanded']
    });
  }
  return 'async';
})()''';
  }
}
