import 'dart:convert';

abstract final class EventObserver {
  static const String hookScript = '''
(function() {
  if (window.__zrHooked) return;
  window.__zrHooked = true;
  var send = function(body) {
    try {
      if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
        window.flutter_inappwebview.callHandler('zrEvents', body);
      }
    } catch (e) {}
  };
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
      var bytesCapOk = !p.messageBytes || p.messageBytes < 262144;
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
        slot.parts[p.fragmentIndex] = b64Bytes(p.dataBase64);
        slot.got++;
        if (slot.got < slot.total) return;
        delete asm[id];
        var idx = asmOrder.indexOf(id);
        if (idx >= 0) asmOrder.splice(idx, 1);
        var size = 0;
        for (var q = 0; q < slot.total; q++) size += (slot.parts[q] || {length:0}).length;
        if (size > 262144) return;
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
      var p = origFetch.apply(this, arguments);
      return p.then(function(res) {
        try {
          if (res.status !== 200) return res;
          var ct = (res.headers && res.headers.get)
              ? (res.headers.get('content-type') || '')
              : '';
          if (/^(image|audio|video|font)\\//.test(ct)) return res;
          var cl = (res.headers && res.headers.get)
              ? res.headers.get('content-length')
              : null;
          if (cl && +cl > 262144) return res;
          res.clone().text().then(function(t) {
            if (t && t.length > 0 && t.length < 262144) send(t);
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
    var WSWrapped = function(url, protocols) {
      var ws = (protocols === undefined)
          ? new OrigWS(url)
          : new OrigWS(url, protocols);
      try {
        ws.addEventListener('message', function(ev) {
          try {
            var d = ev.data;
            if (typeof d === 'string') {
              sendWithDecode(d);
            } else if (d && typeof d.size === 'number') {
              if (d.size > 0 && d.size < 262144) {
                d.text().then(function(t) { sendWithDecode(t); }).catch(function() {});
              }
            } else if (d && d.byteLength > 0 && d.byteLength < 262144) {
              try { sendWithDecode(new TextDecoder('utf-8', {fatal: false}).decode(d)); } catch (e2) {}
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
      if (value is String && kKnownEventTypes.contains(value)) return value;
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

  @override
  bool operator ==(Object other) =>
      other is SessionState && other.sessionId == sessionId;

  @override
  int get hashCode => sessionId.hashCode;
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
    final states = <SessionState>[];
    _walk(root, 0, states);
    return states;
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
    );
  }
}

class StateDiffer {
  StateDiffer();

  final Map<String, SessionState> _prev = {};

  List<ObservedEvent> apply(List<SessionState> incoming) {
    final events = <ObservedEvent>[];
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

abstract final class ActiveSessionExtractor {
  static const int _maxDepth = 6;

  static String? parse(String body) {
    final dynamic root;
    try {
      root = jsonDecode(body);
    } catch (_) {
      return null;
    }
    return _walk(root, 0);
  }

  static String? _walk(dynamic node, int depth) {
    if (depth > _maxDepth || node is! Map) return null;
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
