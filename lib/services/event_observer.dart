import 'dart:convert';

const int kMaxListenBytes = 4194304;

abstract final class EventObserver {
  static String hookScriptFor(int dispatchPort, String dispatchToken) =>
      '''
(function() {
  if (window.__zrHooked) return;
  window.__zrHooked = true;
  var q = [];
  var qBytes = 0;
  var qMaxEntries = 2048;
  var post = function(name, body) {
    try {
      var h = window.flutter_inappwebview;
      if (h && h.callHandler) {
        h.callHandler(name, body);
        return;
      }
      if (q.length >= qMaxEntries) {
        qBytes -= q.shift().b.length;
      }
      q.push({ n: name, b: body });
      qBytes += body.length;
      while (qBytes > $kMaxListenBytes && q.length > 1) {
        qBytes -= q.shift().b.length;
      }
    } catch (e) {}
  };
  var flush = function() {
    var h = window.flutter_inappwebview;
    if (!h || !h.callHandler) return false;
    while (q.length > 0) {
      var m = q.shift();
      qBytes -= m.b.length;
      try { h.callHandler(m.n, m.b); } catch (e) {}
    }
    return true;
  };
  window.addEventListener('flutterInAppWebViewPlatformReady', function() { flush(); }, false);
  var flushTimer = setInterval(function() {
    if (flush()) clearInterval(flushTimer);
  }, 120);
  var send = function(body) { post('zrEvents', body); };
  var asm = {};
  var asmOrder = [];
  var b64Bytes = function(b64) {
    var bin = atob(b64);
    var bytes = new Uint8Array(bin.length);
    for (var k = 0; k < bin.length; k++) bytes[k] = bin.charCodeAt(k);
    return bytes;
  };
  var tryDecodePayload = function(p) {
    try {
      if (!p || typeof p.dataBase64 !== 'string' || p.dataBase64.length === 0) return;
      var sizeHint = p.messageBytes != null ? p.messageBytes : Math.ceil(p.dataBase64.length * 0.75);
      var bytesCapOk = sizeHint < $kMaxListenBytes;
      if (!bytesCapOk) return;
      var bytes;
      if (p.kind === 'fragment' && p.fragmentCount > 1) {
        var id = p.logicalFrameId;
        if (!id) return;
        var slot = asm[id];
        if (!slot) {
          if (asmOrder.length > 32) { delete asm[asmOrder.shift()]; }
          slot = asm[id] = { parts: {}, got: 0, total: p.fragmentCount };
          asmOrder.push(id);
        }
        if (!(p.fragmentIndex in slot.parts)) slot.got++;
        slot.parts[p.fragmentIndex] = b64Bytes(p.dataBase64);
        if (slot.got < slot.total) return;
        delete asm[id];
        var idx = asmOrder.indexOf(id);
        if (idx >= 0) asmOrder.splice(idx, 1);
        var size = 0;
        for (var q = 0; q < slot.total; q++) size += (slot.parts[q] || {length:0}).length;
        if (size > $kMaxListenBytes) return;
        bytes = new Uint8Array(size);
        var off = 0;
        for (var q2 = 0; q2 < slot.total; q2++) {
          var part = slot.parts[q2];
          if (!part) return;
          bytes.set(part, off);
          off += part.length;
        }
      } else {
        bytes = b64Bytes(p.dataBase64);
      }
      var text = new TextDecoder('utf-8', {fatal: false}).decode(bytes);
      if (text && text.length > 0) {
        var first = text.indexOf('{');
        var last = text.lastIndexOf('}');
        if (first > 0 && last > first) {
          text = text.slice(first, last + 1);
        }
        if (text && text.length > 0) send(text);
      }
    } catch (e) {}
  };
  var sendWithDecode = function(body) {
    send(body);
    try {
      var env = JSON.parse(body);
      tryDecodePayload(env && env.payload);
    } catch (e) {}
  };
  var origFetch = window.fetch;
  if (origFetch) {
    window.fetch = function() {
      try {
        var u = arguments[0], init = arguments[1];
        var url = typeof u === 'string' ? u : ((u && u.url) || '');
        if (url.indexOf('http://127.0.0.1:') === 0) {
          return origFetch.apply(this, arguments);
        }
        var method = (init && init.method) || '';
        if (url.indexOf('/mobile-view-state') >= 0 &&
            String(method).toUpperCase() === 'POST') {
          var b = init && init.body;
          if (typeof b === 'string' && b.length > 0) {
            post('zrViewState', b);
          }
        }
      } catch (e) {}
      var p = origFetch.apply(this, arguments);
      return p.then(function(res) {
        try {
          if (res.status !== 200) return res;
          var ct = (res.headers && res.headers.get)
              ? (res.headers.get('content-type') || '')
              : '';
          if (/^(image|audio|video|font)[/]/.test(ct)) return res;
          var cl = (res.headers && res.headers.get)
              ? res.headers.get('content-length')
              : null;
          if (cl && +cl > $kMaxListenBytes) return res;
          res.clone().text().then(function(t) {
            if (t && t.length > 0 && t.length < $kMaxListenBytes) send(t);
          }).catch(function() {});
        } catch (e) {}
        return res;
      });
    };
  }
  var OrigES = window.EventSource;
  if (OrigES) {
    var Wrapped = function(url, cfg) {
      var es = new OrigES(url, cfg);
      es.addEventListener('message', function(ev) { send(ev.data); });
      return es;
    };
    Wrapped.prototype = OrigES.prototype;
    var statics = ['CONNECTING', 'OPEN', 'CLOSED'];
    for (var i = 0; i < statics.length; i++) {
      Wrapped[statics[i]] = OrigES[statics[i]];
    }
    window.EventSource = Wrapped;
  }
  var OrigWS = window.WebSocket;
  if (OrigWS) {
    var wsSend = function(event) {
      post('zrWs', event);
    };
    var WSWrapped = function(url, protocols) {
      var ws = (protocols === undefined)
          ? new OrigWS(url)
          : new OrigWS(url, protocols);
      try {
        var urlStr = (url && url.href) ? url.href : String(url);
        ws.addEventListener('open', function() {
          wsSend(JSON.stringify({s: 'open', u: urlStr}));
        });
        ws.addEventListener('close', function(ev) {
          wsSend(JSON.stringify({s: 'closed', u: urlStr, c: ev && ev.code, r: (ev && ev.reason) || ''}));
        });
        ws.addEventListener('message', function(ev) {
          try { zrPollRevive(); } catch (e9) {}
          try {
            var d = ev.data;
            if (typeof d === 'string') {
              sendWithDecode(d);
            } else if (d && typeof d.size === 'number') {
              if (d.size > 0 && d.size < $kMaxListenBytes) {
                d.text().then(function(t) {
                  sendWithDecode(t);
                }).catch(function() {});
              }
            } else if (d && d.byteLength > 0 && d.byteLength < $kMaxListenBytes) {
              try {
                sendWithDecode(new TextDecoder('utf-8', {fatal: false}).decode(d));
              } catch (e2) {}
            }
          } catch (e) {}
        });
      } catch (e) {}
      return ws;
    };
    WSWrapped.prototype = OrigWS.prototype;
    var wsStatics = ['CONNECTING', 'OPEN', 'CLOSED'];
    for (var j = 0; j < wsStatics.length; j++) {
      WSWrapped[wsStatics[j]] = OrigWS[wsStatics[j]];
    }
    window.WebSocket = WSWrapped;
  }
  var zrSvc = null;
  var zrFindServices = function() {
    try {
      if (zrSvc) {
        var s = zrSvc.zcodeAgentService;
        if (s && typeof s.listAllAutomations === 'function') return zrSvc;
        zrSvc = null;
      }
      var all = document.querySelectorAll('*');
      var fiber = null;
      for (var i = 0; i < all.length && !fiber; i++) {
        var ks = Object.keys(all[i]);
        for (var j2 = 0; j2 < ks.length; j2++) {
          if (ks[j2].lastIndexOf('__reactFiber', 0) === 0) { fiber = all[i][ks[j2]]; break; }
        }
      }
      if (!fiber) return null;
      while (fiber.return) fiber = fiber.return;
      var seen = new Set();
      var found = null;
      var check = function(o) {
        try {
          if (!o || typeof o !== 'object' || seen.has(o)) return false;
          seen.add(o);
          var ks2 = Object.keys(o);
          var c = 0;
          var hasAg = false;
          var hasOp = false;
          for (var q = 0; q < ks2.length; q++) {
            var k = ks2[q];
            if (k.length > 7 && k.substring(k.length - 7) === 'Service') c++;
            if (k === 'zcodeAgentService') hasAg = true;
            if (k === 'offPeakTaskService') hasOp = true;
          }
          if (c >= 10 && hasAg && hasOp) { found = o; zrSvc = o; return true; }
          return false;
        } catch (e) { return false; }
      };
      var walk = function(f, depth) {
        if (!f || found || depth > 20000) return;
        try {
          var st = f.memoizedState;
          var n = 0;
          while (st && typeof st === 'object' && n < 40) {
            if (st.memoizedState !== undefined && check(st.memoizedState)) return;
            st = st.next;
            n++;
          }
          if (f.stateNode && typeof f.stateNode === 'object' && !(f.stateNode instanceof Node)) {
            if (check(f.stateNode)) return;
          }
          var props = f.memoizedProps;
          if (props && typeof props === 'object' && !Array.isArray(props)) {
            var pk = Object.keys(props);
            for (var p = 0; p < pk.length && p < 30; p++) {
              var v = props[pk[p]];
              if (v && typeof v === 'object') {
                if (check(v)) return;
                if (v.value && check(v.value)) return;
                if (v.current && check(v.current)) return;
              }
            }
          }
        } catch (e) {}
        walk(f.child, depth + 1);
        if (!found) walk(f.sibling, depth + 1);
      };
      walk(fiber, 0);
      return found;
    } catch (e) { return null; }
  };
  var zrSeen = {};
  function zrProbeRun(id, method, argsB64) {
    try {
      if (method !== 'dump') { post('zrSvcResult', JSON.stringify({ i: id, ok: false, e: 'no-method' })); return; }
      var c = zrFindServices();
      if (!c) { post('zrSvcResult', JSON.stringify({ i: id, ok: false, e: 'no-services' })); return; }
      var list = [];
      if (argsB64) {
        try {
          var pb = atob(argsB64);
          var pbytes = new Uint8Array(pb.length);
          for (var pi = 0; pi < pb.length; pi++) pbytes[pi] = pb.charCodeAt(pi);
          var pa = JSON.parse(new TextDecoder('utf-8', {fatal: false}).decode(pbytes));
          if (Array.isArray(pa) && pa.length === 1 && Array.isArray(pa[0])) list = pa[0];
        } catch (e2) {}
      }
      var checks = {};
      for (var ci = 0; ci < list.length; ci++) {
        var item = list[ci];
        if (!item || typeof item !== 'object') continue;
        var skey = item.s;
        var ms = item.m;
        if (typeof skey !== 'string' || !ms || !Array.isArray(ms)) continue;
        var svc = c[skey];
        for (var mi = 0; mi < ms.length; mi++) {
          if (typeof ms[mi] !== 'string') continue;
          checks[skey + '.' + ms[mi]] = svc ? (typeof svc[ms[mi]] === 'function') : 'no-svc';
        }
      }
      post('zrSvcResult', JSON.stringify({ i: id, ok: true, r: JSON.stringify({ keys: Object.keys(c), checks: checks }) }));
    } catch (e) { post('zrSvcResult', JSON.stringify({ i: id, ok: false, e: 'probe-err' })); }
  }
  var zrCapBusy = false;
  function zrCaptchaRun(id, argsB64) {
    try {
      var cfg = {};
      if (argsB64) {
        try {
          var cb = atob(argsB64);
          var cbytes = new Uint8Array(cb.length);
          for (var ci = 0; ci < cb.length; ci++) cbytes[ci] = cb.charCodeAt(ci);
          var ca = JSON.parse(new TextDecoder('utf-8', {fatal: false}).decode(cbytes));
          if (ca && typeof ca === 'object' && ca.length) cfg = ca[0] || {};
        } catch (e0) {}
      }
      if (zrCapBusy) { post('zrSvcResult', JSON.stringify({ i: id, ok: false,
        e: 'captcha-busy' })); return 'busy'; }
      zrCapBusy = true;
      var timeoutMs = (typeof cfg.timeoutMs === 'number' && cfg.timeoutMs > 0) ? cfg.timeoutMs : 8000;
      var settle = false;
      var finish = function(payload) {
        if (settle) return; settle = true; zrCapBusy = false;
        post('zrSvcResult', JSON.stringify({ i: id, ok: true,
          r: JSON.stringify(payload) }));
      };
      var run = function() {
        try {
          window.AliyunCaptchaConfig = { region: cfg.region || 'cn', prefix: cfg.prefix || '' };
          if (!document.getElementById('zr-cap-holder')) {
            var h = document.createElement('div'); h.id = 'zr-cap-holder';
            var b = document.createElement('button'); b.id = 'zr-cap-btn';
            b.style.display = 'none';
            document.body.appendChild(h); document.body.appendChild(b);
          }
          window.initAliyunCaptcha({
            SceneId: cfg.sceneId || '',
            mode: 'popup',
            language: 'zh-CN',
            showErrorTip: false,
            element: '#zr-cap-holder',
            button: '#zr-cap-btn',
            getInstance: function(i) {
              try { if (i && typeof i.startTracelessVerification === 'function') i.startTracelessVerification();
              else finish({ ok: false, reason: 'interactive-required' }); } catch (e1) {
                finish({ ok: false, reason: 'interactive-required' }); }
            },
            success: function(p) {
              var v = (typeof p === 'string') ? p : (p && p.captchaVerifyParam);
              finish(v ? { ok: true, param: v } : { ok: false, reason: 'no-param' });
            },
            fail: function() { finish({ ok: false, reason: 'interactive-required' }); },
            onError: function() { finish({ ok: false, reason: 'captcha-error' }); },
          });
          setTimeout(function() { finish({ ok: false, reason: 'timeout' }); }, timeoutMs);
        } catch (e2) { finish({ ok: false, reason: 'init-failed' }); }
      };
      if (typeof window.initAliyunCaptcha === 'function') { run(); return 'queued'; }
      var s = document.createElement('script');
      s.src = 'https://o.alicdn.com/captcha-frontend/aliyunCaptcha/AliyunCaptcha.js';
      s.onload = run;
      s.onerror = function() { finish({ ok: false, reason: 'sdk-load-failed' }); };
      document.head.appendChild(s);
      return 'queued';
    } catch (e) { zrCapBusy = false; return 'err'; }
  }
  window.__zrSvcCall = function(id, svcKey, method, argsB64) {
    try {
      if (zrSeen[id]) return 'dup';
      if (Object.keys(zrSeen).length > 2000) zrSeen = {};
      zrSeen[id] = 1;
      if (svcKey === '__zrProbe') { zrProbeRun(id, method, argsB64); return 'queued'; }
      if (svcKey === '__zrCaptcha') { zrCaptchaRun(id, argsB64); return 'queued'; }
      var c = zrFindServices();
      if (!c) { post('zrSvcResult', JSON.stringify({ i: id, ok: false, e: 'no-services' })); return 'queued'; }
      var svc = c[svcKey];
      if (!svc || typeof svc[method] !== 'function') { post('zrSvcResult', JSON.stringify({ i: id, ok: false, e: 'no-method' })); return 'queued'; }
      var args = [];
      if (argsB64) {
        try {
          var ab = atob(argsB64);
          var abytes = new Uint8Array(ab.length);
          for (var ai = 0; ai < ab.length; ai++) abytes[ai] = ab.charCodeAt(ai);
          var a = JSON.parse(new TextDecoder('utf-8', {fatal: false}).decode(abytes));
          if (typeof a === 'object' && a && typeof a.length === 'number') args = a;
          else args = [a];
        } catch (e2) {}
      }
      Promise.resolve(svc[method].apply(svc, args)).then(function(r) {
        var out;
        try { out = JSON.stringify(r); } catch (e3) { out = null; }
        if (typeof out === 'string' && out.length > $kMaxListenBytes) out = out.substring(0, $kMaxListenBytes);
        post('zrSvcResult', JSON.stringify({ i: id, ok: true, r: out === null ? undefined : out }));
      }, function(err) {
        var msg = 'err';
        try { msg = String(err && err.message ? err.message : err); } catch (e4) {}
        if (msg.length > 500) msg = msg.substring(0, 500);
        post('zrSvcResult', JSON.stringify({ i: id, ok: false, e: msg }));
      });
      return 'queued';
    } catch (e) { return 'err'; }
  };
  var zrPollBusy = false;
  var zrPollAt = 0;
  function zrPollStart() {
    if (zrPollBusy) return;
    zrPollBusy = true;
    zrPollAt = Date.now();
    fetch('http://127.0.0.1:' + $dispatchPort + '/zrp/' + '$dispatchToken', { mode: 'cors' })
      .then(function(r) {
        if (!r.ok) throw new Error('http ' + r.status);
        return r.json();
      })
      .then(function(j) {
        zrPollBusy = false;
        try {
          if (j && j.c) {
            for (var pk = 0; pk < j.c.length; pk++) {
              var x = j.c[pk];
              window.__zrSvcCall(x.i, x.s, x.m, x.a);
            }
          }
        } catch (e5) {}
        zrPollStart();
      })
      .catch(function() {
        zrPollBusy = false;
        setTimeout(function() { zrPollStart(); }, 1500);
      });
  }
  function zrPollRevive() {
    if (!zrPollBusy) {
      zrPollStart();
      return;
    }
    if (Date.now() - zrPollAt > 45000) {
      zrPollBusy = false;
      zrPollStart();
    }
  }
  zrPollStart();
})();
''';
}

const Set<String> kKnownEventTypes = {
  'created',
  'prompt_sent',
  'resumed',
  'streaming',
  'permission_request',
  'permission_resolved',
  'elicitation_request',
  'elicitation_resolved',
  'updated',
  'completed',
  'error',
};

const Set<String> kNotifiableTypes = {
  'permission_request',
  'elicitation_request',
  'completed',
  'error',
};

const Map<String, String> kEventTypeAliases = {
  'task_complete': 'completed',
  'task_error': 'error',
  'permission_response': 'permission_resolved',
  'elicitation_response': 'elicitation_resolved',
};

class ObservedEvent {
  const ObservedEvent({
    required this.type,
    this.taskId,
    this.sessionTitle,
    this.summary,
  });

  final String type;

  final String? taskId;

  final String? sessionTitle;

  final String? summary;
}

abstract final class EventParser {
  static const int _maxDepth = 3;

  static List<ObservedEvent> parseMessage(String body) {
    final dynamic root;
    try {
      root = jsonDecode(body);
    } catch (_) {
      return const [];
    }
    return parseRoot(root);
  }

  static List<ObservedEvent> parseRoot(dynamic root) {
    final events = <ObservedEvent>[];
    _walk(root, 0, events);
    return events;
  }

  static void _walk(dynamic node, int depth, List<ObservedEvent> out) {
    if (depth > _maxDepth || node == null) return;
    if (node is Map) {
      final type = _eventTypeOf(node);
      if (type != null) out.add(_eventFrom(node, type));
      for (final value in node.values) {
        _walk(value, depth + 1, out);
      }
    } else if (node is List) {
      for (final value in node) {
        _walk(value, depth + 1, out);
      }
    }
  }

  static String? _eventTypeOf(Map<dynamic, dynamic> node) {
    for (final key in const ['event', 'type']) {
      final value = node[key];
      if (value is! String) continue;
      if (kKnownEventTypes.contains(value)) return value;
      final aliased = kEventTypeAliases[value];
      if (aliased != null) return aliased;
    }
    return null;
  }

  static ObservedEvent _eventFrom(Map<dynamic, dynamic> node, String type) {
    String? taskId;
    for (final key in const ['taskId', 'task_id']) {
      final value = node[key];
      if (value is String && value.isNotEmpty) {
        taskId = value;
        break;
      }
    }

    String? summary;
    if (type == 'permission_request' || type == 'elicitation_request') {
      for (final key in const ['title', 'description', 'kind', 'toolName']) {
        final value = node[key];
        if (value is String && value.isNotEmpty) {
          summary = value;
          break;
        }
      }
    }

    return ObservedEvent(type: type, taskId: taskId, summary: summary);
  }
}

class SessionState {
  const SessionState({
    required this.sessionId,
    this.title,
    this.phase,
    this.sessionEnded,
    this.permissionCount = 0,
    this.userInputCount = 0,
    this.interactionKind,
    this.toolName,
    this.description,
    this.lastActivityAt,
    this.createdAt,
    this.workspace,
    this.pinned = false,
  });

  final String sessionId;
  final String? title;
  final String? phase;
  final bool? sessionEnded;
  final int permissionCount;
  final int userInputCount;
  final String? interactionKind;
  final String? toolName;

  final String? description;

  final int? lastActivityAt;

  final int? createdAt;

  final String? workspace;

  final bool pinned;

  @override
  bool operator ==(Object other) =>
      other is SessionState &&
      other.sessionId == sessionId &&
      other.title == title &&
      other.phase == phase &&
      other.sessionEnded == sessionEnded &&
      other.permissionCount == permissionCount &&
      other.userInputCount == userInputCount &&
      other.interactionKind == interactionKind &&
      other.toolName == toolName &&
      other.description == description &&
      other.lastActivityAt == lastActivityAt &&
      other.createdAt == createdAt &&
      other.workspace == workspace &&
      other.pinned == pinned;

  @override
  int get hashCode => Object.hashAll([
    sessionId,
    title,
    phase,
    sessionEnded,
    permissionCount,
    userInputCount,
    interactionKind,
    toolName,
    description,
    lastActivityAt,
    createdAt,
    workspace,
    pinned,
  ]);
}

abstract final class SessionStateExtractor {
  static const int _maxDepth = 8;

  static List<SessionState> parse(String body) {
    final dynamic root;
    try {
      root = jsonDecode(body);
    } catch (_) {
      return const [];
    }
    return parseRoot(root);
  }

  static List<SessionState> parseRoot(dynamic root) {
    final states = <SessionState>[];
    _walk(root, 0, states);
    return states;
  }

  static List<String> parseRemoved(String body) {
    final dynamic root;
    try {
      root = jsonDecode(body);
    } catch (_) {
      return const [];
    }
    return parseRemovedRoot(root);
  }

  static List<String> parseRemovedRoot(dynamic root) {
    final removed = <String>[];
    _walkRemoved(root, 0, removed);
    return removed;
  }

  static void _walkRemoved(dynamic node, int depth, List<String> out) {
    if (depth > _maxDepth || node == null) return;
    if (node is Map) {
      if (node['op'] == 'session.removed') {
        final id = node['sessionId'];
        if (id is String && id.isNotEmpty) out.add(id);
      }
      for (final value in node.values) {
        _walkRemoved(value, depth + 1, out);
      }
    } else if (node is List) {
      for (final value in node) {
        _walkRemoved(value, depth + 1, out);
      }
    }
  }

  static String? workspaceBasenameOf(String? id) {
    if (id == null) return null;
    final trimmed = id.trim();
    if (trimmed.isEmpty) return null;
    final slash = trimmed.lastIndexOf('/');
    final backslash = trimmed.lastIndexOf(r'\');
    final cut = slash > backslash ? slash : backslash;
    final base = (cut < 0 ? trimmed : trimmed.substring(cut + 1)).trim();
    return base.isEmpty ? null : base;
  }

  static void _walk(dynamic node, int depth, List<SessionState> out) {
    if (depth > _maxDepth || node == null) return;
    if (node is Map) {
      final state = _stateOf(node);
      if (state != null) out.add(state);
      for (final value in node.values) {
        _walk(value, depth + 1, out);
      }
    } else if (node is List) {
      for (final value in node) {
        _walk(value, depth + 1, out);
      }
    }
  }

  static SessionState? _stateOf(Map<dynamic, dynamic> node) {
    final id = node['sessionId'];
    if (id is! String || id.isEmpty) return null;
    final hasSummary = node['pendingInteractionSummary'] is Map;
    final hasEnded = node['sessionEnded'] is bool;
    final hasPhase = node['phase'] is String;
    if (!hasSummary && !hasEnded && !hasPhase) return null;

    var permCount = 0;
    var userInputCount = 0;
    final summary = node['pendingInteractionSummary'];
    if (summary is Map) {
      final p = summary['permissionCount'];
      final u = summary['userInputCount'];
      if (p is int) permCount = p;
      if (u is int) userInputCount = u;
    }

    String? interactionKind;
    String? toolName;
    String? description;
    final interaction = node['pendingInteraction'];
    if (interaction is Map) {
      final k = interaction['kind'];
      final t = interaction['toolName'];
      if (k is String) interactionKind = k;
      if (t is String) toolName = t;
      for (final key in const ['description', 'summary']) {
        final d = interaction[key];
        if (d is String && d.isNotEmpty) {
          description = d;
          break;
        }
      }
    }

    final title = node['title'];
    final laa = node['lastActivityAt'];
    final ca = node['createdAt'];
    final ws = node['workspaceId'];
    return SessionState(
      sessionId: id,
      title: title is String ? title : null,
      phase: node['phase'] is String ? node['phase'] as String? : null,
      sessionEnded: node['sessionEnded'] is bool
          ? node['sessionEnded'] as bool?
          : null,
      permissionCount: permCount,
      userInputCount: userInputCount,
      interactionKind: interactionKind,
      toolName: toolName,
      description: description,
      lastActivityAt: laa is num ? laa.toInt() : null,
      createdAt: ca is num ? ca.toInt() : null,
      workspace: workspaceBasenameOf(ws is String ? ws : null),
    );
  }
}

abstract final class TaskIndexExtractor {
  static const int _maxDepth = 8;

  static List<SessionState> parse(String body) {
    final dynamic root;
    try {
      root = jsonDecode(body);
    } catch (_) {
      return const [];
    }
    return parseRoot(root);
  }

  static List<SessionState> parseRoot(dynamic root) {
    final states = <SessionState>[];
    _walk(root, 0, states);
    return states;
  }

  static void _walk(dynamic node, int depth, List<SessionState> out) {
    if (depth > _maxDepth || node == null) return;
    if (node is Map) {
      if (node['op'] == 'task.upserted' && node['task'] is Map) {
        final state = _stateOf(node['task'] as Map<dynamic, dynamic>);
        if (state != null) out.add(state);
      }
      for (final value in node.values) {
        _walk(value, depth + 1, out);
      }
    } else if (node is List) {
      for (final value in node) {
        _walk(value, depth + 1, out);
      }
    }
  }

  static List<String> parseArchived(String body) {
    final dynamic root;
    try {
      root = jsonDecode(body);
    } catch (_) {
      return const [];
    }
    return parseArchivedRoot(root);
  }

  static List<String> parseArchivedRoot(dynamic root) {
    final archived = <String>[];
    _walkArchived(root, 0, archived);
    return archived;
  }

  static List<String> parseRemoved(String body) {
    final dynamic root;
    try {
      root = jsonDecode(body);
    } catch (_) {
      return const [];
    }
    return parseRemovedRoot(root);
  }

  static List<String> parseRemovedRoot(dynamic root) {
    final removed = <String>[];
    _walkRemoved(root, 0, removed);
    return removed;
  }

  static void _walkRemoved(dynamic node, int depth, List<String> out) {
    if (depth > _maxDepth || node == null) return;
    if (node is Map) {
      if (node['op'] == 'task.removed' && node['address'] is Map) {
        final id = (node['address'] as Map<dynamic, dynamic>)['taskId'];
        if (id is String && id.isNotEmpty) out.add(id);
      }
      for (final value in node.values) {
        _walkRemoved(value, depth + 1, out);
      }
    } else if (node is List) {
      for (final value in node) {
        _walkRemoved(value, depth + 1, out);
      }
    }
  }

  static void _walkArchived(dynamic node, int depth, List<String> out) {
    if (depth > _maxDepth || node == null) return;
    if (node is Map) {
      if (node['op'] == 'task.upserted' && node['task'] is Map) {
        final task = node['task'] as Map<dynamic, dynamic>;
        final membership = task['membership'];
        if (membership is Map && membership['archived'] == true) {
          final id = _taskIdOf(task);
          if (id != null) out.add(id);
        }
      }
      for (final value in node.values) {
        _walkArchived(value, depth + 1, out);
      }
    } else if (node is List) {
      for (final value in node) {
        _walkArchived(value, depth + 1, out);
      }
    }
  }

  static String? _taskIdOf(Map<dynamic, dynamic> task) {
    final address = task['address'];
    if (address is Map) {
      final id = address['taskId'];
      if (id is String && id.isNotEmpty) return id;
    }
    final meta = task['meta'];
    if (meta is Map) {
      final id = meta['taskId'];
      if (id is String && id.isNotEmpty) return id;
    }
    return null;
  }

  static List<SessionState>? parseSnapshot(String body) {
    final dynamic root;
    try {
      root = jsonDecode(body);
    } catch (_) {
      return null;
    }
    return parseSnapshotRoot(root);
  }

  static List<SessionState>? parseSnapshotRoot(dynamic root) {
    final snapshot = _findTasksSnapshot(root, 0);
    if (snapshot == null) return null;
    final out = <SessionState>[];
    for (final t in snapshot) {
      if (t is Map<dynamic, dynamic>) {
        final state = _stateOf(t);
        if (state != null) out.add(state);
      }
    }
    return out;
  }

  static List<dynamic>? _findTasksSnapshot(dynamic node, int depth) {
    if (depth > _maxDepth || node is! Map) return null;
    final payload = node['payload'];
    if (payload is Map && payload['kind'] == 'snapshot') {
      final snapshot = payload['snapshot'];
      if (snapshot is Map && snapshot['tasks'] is List) {
        return snapshot['tasks'] as List<dynamic>;
      }
    }
    for (final value in node.values) {
      final found = _findTasksSnapshot(value, depth + 1);
      if (found != null) return found;
    }
    return null;
  }

  static List<SessionState>? parseResultTasks(String body) {
    final dynamic root;
    try {
      root = jsonDecode(body);
    } catch (_) {
      return null;
    }
    return parseResultTasksRoot(root);
  }

  static List<SessionState>? parseResultTasksRoot(dynamic root) {
    final tasks = _findResultTasks(root, 0);
    if (tasks == null) return null;
    final out = <SessionState>[];
    for (final t in tasks) {
      if (t is! Map<dynamic, dynamic>) continue;
      final state = _stateOfFlat(t);
      if (state != null) out.add(state);
    }
    return out;
  }

  static List<dynamic>? _findResultTasks(dynamic node, int depth) {
    if (depth > _maxDepth || node is! Map) return null;
    final result = node['result'];
    if (result is Map && result['tasks'] is List) {
      return result['tasks'] as List<dynamic>;
    }
    for (final value in node.values) {
      final found = _findResultTasks(value, depth + 1);
      if (found != null) return found;
    }
    return null;
  }

  static bool isBootstrapResult(dynamic root) {
    if (root is! Map) return false;
    final payload = root['payload'];
    if (payload is! Map) return false;
    final requestId = payload['requestId'];
    return requestId is String && requestId.startsWith('bootstrap');
  }

  static SessionState? _stateOfFlat(Map<dynamic, dynamic> t) {
    final id = t['taskId'];
    if (id is! String || id.isEmpty) return null;
    final status = t['displayStatus'];
    final phase = status is String ? _phaseFromStatus(status) : null;
    final laa = t['updatedAt'];
    final ca = t['createdAt'];
    final wsPath = t['workspacePath'];
    final wsLabel = t['workspaceLabel'];
    return SessionState(
      sessionId: id,
      title: t['title'] is String ? t['title'] as String? : null,
      phase: phase,
      lastActivityAt: laa is num ? laa.toInt() : null,
      createdAt: ca is num ? ca.toInt() : null,
      workspace: wsLabel is String && wsLabel.isNotEmpty
          ? wsLabel
          : SessionStateExtractor.workspaceBasenameOf(
              wsPath is String ? wsPath : null,
            ),
    );
  }

  static SessionState? _stateOf(Map<dynamic, dynamic> task) {
    final taskId = _taskIdOf(task);
    if (taskId == null) return null;

    final membership = task['membership'];
    if (membership is Map && membership['archived'] == true) return null;

    final address = task['address'];
    final meta = task['meta'];
    final activity = task['activity'];

    String? workspacePath;
    if (address is Map) {
      final p = address['workspacePath'];
      if (p is String && p.isNotEmpty) workspacePath = p;
    }
    if (workspacePath == null && meta is Map) {
      final p = meta['workspacePath'];
      if (p is String && p.isNotEmpty) workspacePath = p;
    }

    String? title;
    if (meta is Map) {
      final t = meta['title'];
      if (t is String && t.isNotEmpty) title = t;
    }

    int? lastActivityAt;
    if (activity is Map) {
      final v = activity['lastActivityAt'];
      if (v is num) lastActivityAt = v.toInt();
    }
    if (lastActivityAt == null && meta is Map) {
      final v = meta['updatedAt'];
      if (v is num) lastActivityAt = v.toInt();
    }

    int? createdAt;
    if (meta is Map) {
      final v = meta['createdAt'];
      if (v is num) createdAt = v.toInt();
    }

    String? phase;
    if (activity is Map) {
      final p = activity['phase'];
      if (p is String && p.isNotEmpty) phase = p;
    }
    if (phase == null) {
      final live = task['liveStatus'];
      if (live is String && live.isNotEmpty) phase = live;
    }
    if (phase == null && meta is Map) {
      final status = meta['status'];
      if (status is String) phase = _phaseFromStatus(status);
    }

    return SessionState(
      sessionId: taskId,
      title: title,
      phase: phase,
      lastActivityAt: lastActivityAt,
      createdAt: createdAt,
      workspace: SessionStateExtractor.workspaceBasenameOf(workspacePath),
      pinned: membership is Map && membership['pinned'] == true,
    );
  }

  static String? _phaseFromStatus(String status) => switch (status) {
    'completed' => 'completedSuccess',
    'error' => 'error',
    'running' => 'running',
    _ => null,
  };
}

abstract final class CodingPlanSignalExtractor {
  static const int _maxDepth = 6;

  static String? parseRoot(dynamic root) => _walk(root, 0);

  static String? _walk(dynamic node, int depth) {
    if (depth > _maxDepth || node is! Map) return null;
    final providers = node['providers'];
    if (providers is List) {
      for (final provider in providers) {
        if (provider is! Map) continue;
        if (provider['providerId'] != 'builtin:bigmodel-coding-plan') continue;
        final apiKey = provider['apiKey'];
        if (apiKey is Map && apiKey.isNotEmpty) {
          return 'builtin:bigmodel-coding-plan';
        }
      }
    }
    String? found;
    for (final value in node.values) {
      found = _walk(value, depth + 1);
      if (found != null) return found;
    }
    return null;
  }
}

abstract final class OffPeakTaskExtractor {
  static const int _maxDepth = 6;

  static ({List<Map<String, dynamic>> tasks, int queued})? parseRoot(
    dynamic root,
  ) {
    final tasks = <Map<String, dynamic>>[];
    _walk(root, 0, tasks);
    if (tasks.isEmpty) return null;
    var queued = 0;
    for (final task in tasks) {
      if (task['status'] == 'queued') queued++;
    }
    return (tasks: tasks, queued: queued);
  }

  static void _walk(dynamic node, int depth, List<Map<String, dynamic>> out) {
    if (depth > _maxDepth || node == null) return;
    if (node is Map) {
      if (node['offPeakTaskId'] is String &&
          (node['offPeakTaskId'] as String).isNotEmpty) {
        out.add(Map<String, dynamic>.from(node));
      }
      for (final value in node.values) {
        _walk(value, depth + 1, out);
      }
    } else if (node is List) {
      for (final value in node) {
        _walk(value, depth + 1, out);
      }
    }
  }
}

abstract final class AutomationExtractor {
  static const int _maxDepth = 6;

  static List<Map<String, dynamic>>? parseRoot(dynamic root) {
    final automations = <Map<String, dynamic>>[];
    _walk(root, 0, automations);
    return automations.isEmpty ? null : automations;
  }

  static void _walk(dynamic node, int depth, List<Map<String, dynamic>> out) {
    if (depth > _maxDepth || node == null) return;
    if (node is Map) {
      if (node['automationId'] is String &&
          (node['automationId'] as String).isNotEmpty &&
          node['runId'] == null) {
        out.add(Map<String, dynamic>.from(node));
      }
      for (final value in node.values) {
        _walk(value, depth + 1, out);
      }
    } else if (node is List) {
      for (final value in node) {
        _walk(value, depth + 1, out);
      }
    }
  }
}

abstract final class AutomationFeed {
  static ({List<Map<String, dynamic>> tasks, bool snapshot}) offPeakOf(
    List<dynamic> inputs,
  ) {
    final tasks = <Map<String, dynamic>>[];
    for (final input in inputs) {
      final parsed = OffPeakTaskExtractor.parseRoot(input);
      if (parsed != null) tasks.addAll(parsed.tasks);
    }
    return (tasks: tasks, snapshot: tasks.length >= 2);
  }

  static ({List<Map<String, dynamic>> automations, bool snapshot})
  automationsOf(List<dynamic> inputs) {
    final automations = <Map<String, dynamic>>[];
    for (final input in inputs) {
      final parsed = AutomationExtractor.parseRoot(input);
      if (parsed != null) automations.addAll(parsed);
    }
    return (automations: automations, snapshot: automations.length >= 2);
  }
}

abstract final class RecentProjectsExtractor {
  static const int _maxDepth = 4;

  static List<String>? parseRoot(dynamic root) {
    final found = _walk(root, 0);
    return found;
  }

  static List<String>? _walk(dynamic node, int depth) {
    if (depth > _maxDepth || node is! Map) return null;
    final value = node['recentProjects'];
    if (value is List && value.isNotEmpty) {
      final projects = <String>[];
      for (final item in value) {
        if (item is String && item.isNotEmpty) projects.add(item);
      }
      if (projects.isNotEmpty) return projects;
    }
    for (final child in node.values) {
      final found = _walk(child, depth + 1);
      if (found != null) return found;
    }
    return null;
  }
}

class StateDiffer {
  StateDiffer();

  final Map<String, SessionState> _prev = {};

  List<ObservedEvent> apply(
    List<SessionState> incoming, {
    List<String> removed = const [],
  }) {
    final events = <ObservedEvent>[];
    for (final id in removed) {
      final gone = _prev.remove(id);
      if (gone != null &&
          (gone.permissionCount > 0 || gone.userInputCount > 0)) {
        events.add(
          ObservedEvent(type: 'resolved', taskId: id, sessionTitle: gone.title),
        );
      }
    }
    for (final next in incoming) {
      final prev = _prev[next.sessionId];
      _prev[next.sessionId] = next;

      final prevPerm = prev?.permissionCount ?? 0;
      final prevInput = prev?.userInputCount ?? 0;

      if (next.permissionCount > 0 && prevPerm == 0) {
        events.add(
          ObservedEvent(
            type: 'permission_request',
            taskId: next.sessionId,
            sessionTitle: next.title,
            summary: next.description,
          ),
        );
      }
      if (next.userInputCount > 0 && prevInput == 0) {
        events.add(
          ObservedEvent(
            type: 'elicitation_request',
            taskId: next.sessionId,
            sessionTitle: next.title,
            summary: next.description,
          ),
        );
      }

      if ((prevPerm > 0 && next.permissionCount == 0) ||
          (prevInput > 0 && next.userInputCount == 0)) {
        events.add(
          ObservedEvent(
            type: 'resolved',
            taskId: next.sessionId,
            sessionTitle: next.title,
          ),
        );
      }

      final prevPhase = prev?.phase;
      final phase = next.phase;
      const donePhases = {'completedSuccess', 'completedInterrupted'};
      final isDone = phase != null && donePhases.contains(phase);
      final wasDone = prevPhase != null && donePhases.contains(prevPhase);
      if (prev != null && isDone && !wasDone) {
        events.add(
          ObservedEvent(
            type: 'completed',
            taskId: next.sessionId,
            sessionTitle: next.title,
          ),
        );
      }
      if (prev != null && phase == 'error' && prevPhase != 'error') {
        events.add(
          ObservedEvent(
            type: 'error',
            taskId: next.sessionId,
            sessionTitle: next.title,
          ),
        );
      }
    }
    return events;
  }
}

abstract final class MobileViewStateSync {
  static ({bool valid, String? taskId}) parse(String body) {
    final dynamic root;
    try {
      root = jsonDecode(body);
    } catch (_) {
      return (valid: false, taskId: null);
    }
    if (root is! Map) return (valid: false, taskId: null);
    if (root['activeWorkspaceKey'] is! String) {
      return (valid: false, taskId: null);
    }
    final id = root['activeTaskId'];
    return (valid: true, taskId: id is String && id.isNotEmpty ? id : null);
  }
}

abstract final class ActiveSessionExtractor {
  static const int _maxDepth = 6;

  static String? parse(String body) {
    final dynamic root;
    try {
      root = jsonDecode(body);
    } catch (_) {
      return null;
    }
    return parseRoot(root);
  }

  static String? parseRoot(dynamic root) => _walk(root, 0);

  static String? _walk(dynamic node, int depth) {
    if (depth > _maxDepth || node is! Map) return null;
    final topic = node['topic'];
    if (topic is String && topic.startsWith('conversation/')) {
      final sid = topic.substring('conversation/'.length);
      if (sid.isNotEmpty) return sid;
    }
    final view = node['mobileViewState'];
    if (view is Map) {
      final id = view['activeTaskId'];
      if (id is String && id.isNotEmpty) return id;
    }
    final bridge = node['bridge'];
    if (bridge is Map) {
      final id = bridge['initialTaskId'];
      if (id is String && id.isNotEmpty) return id;
    }
    String? found;
    for (final value in node.values) {
      found = _walk(value, depth + 1);
      if (found != null) return found;
    }
    return null;
  }
}

abstract final class NotificationGate {
  static bool shouldNotify({
    required bool appForeground,
    required String? visibleDeviceId,
    required String eventDeviceId,
    required String? activeSessionId,
    required String? eventSessionId,
  }) {
    if (!appForeground) return true;
    if (eventDeviceId != visibleDeviceId) return true;
    if (eventSessionId == null) return true;
    return eventSessionId != activeSessionId;
  }
}
