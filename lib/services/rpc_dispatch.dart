import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

abstract interface class RpcDispatch {
  int get port;

  Future<void> start();

  void push(Map<String, Object?> command);

  void dispose();
}

class LoopbackDispatchServer implements RpcDispatch {
  LoopbackDispatchServer({
    this.hold = const Duration(seconds: 20),
    this.ttl = const Duration(seconds: 30),
  }) : token = _genToken();

  final Duration hold;

  final Duration ttl;

  final String token;

  String get pollPath => '/zrp/$token';

  static String _genToken() {
    final r = Random.secure();
    return [for (var i = 0; i < 16; i++) r.nextInt(16).toRadixString(16)]
        .join();
  }

  HttpServer? _server;
  final List<({Map<String, Object?> cmd, DateTime at})> _queue = [];

  @override
  int get port => _server?.port ?? 0;

  final List<Completer<void>> _waiters = [];

  @override
  Future<void> start() async {
    if (_server != null) return;
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server = server;
    server.listen(
      (request) => unawaited(_handle(request)),
      onError: (Object _) {},
      cancelOnError: false,
    );
  }

  Future<void> _handle(HttpRequest request) async {
    try {
      if (request.uri.path != pollPath) {
        request.response.statusCode = HttpStatus.notFound;
        _close(request);
        return;
      }
      if (request.method == 'OPTIONS') {
        _cors(request, HttpStatus.noContent);
        _close(request);
        return;
      }
      if (request.method == 'GET') {
        _cors(request, HttpStatus.ok);
        _prune();
        if (_queue.isNotEmpty) {
          await _respondBatch(request);
          return;
        }
        final waiter = Completer<void>();
        _waiters.add(waiter);
        try {
          await waiter.future.timeout(hold, onTimeout: () {});
        } on TimeoutException { // ignore: empty_catches
        }
        _waiters.remove(waiter);
        if (_queue.isNotEmpty) {
          await _respondBatch(request);
        } else {
          request.response.write('{"c":[]}');
          _close(request);
        }
        return;
      }
      request.response.statusCode = HttpStatus.notFound;
      _close(request);
    } catch (_) {
      _close(request);
    }
  }

  void _close(HttpRequest request) {
    try {
      request.response.close().ignore();
    } catch (_) {}
  }

  Future<void> _respondBatch(HttpRequest request) async {
    final batch = [for (final e in _queue) e.cmd];
    try {
      request.response.write(jsonEncode({'c': batch}));
      await request.response.close();
      _queue.clear();
    } catch (_) {
      _wakeOne();
    }
  }

  void _cors(HttpRequest request, int status) {
    final headers = request.response.headers;
    headers.set('Access-Control-Allow-Origin', '*');
    headers.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
    headers.set('Access-Control-Allow-Headers', '*');
    headers.set('Access-Control-Max-Age', '86400');
    headers.set('Access-Control-Allow-Private-Network', 'true');
    headers.set('Cache-Control', 'no-store');
    request.response.statusCode = status;
    if (status == HttpStatus.noContent) {
      headers.contentType = ContentType('text', 'plain');
    } else {
      headers.contentType = ContentType.json;
    }
  }

  @override
  void push(Map<String, Object?> command) {
    _prune();
    _queue.add((cmd: command, at: DateTime.now()));
    _wakeOne();
  }

  void _wakeOne() {
    while (_waiters.isNotEmpty) {
      final waiter = _waiters.removeLast();
      if (!waiter.isCompleted) {
        waiter.complete();
        break;
      }
    }
  }

  void _prune() {
    final deadline = DateTime.now().subtract(ttl);
    _queue.removeWhere((e) => e.at.isBefore(deadline));
  }

  @override
  void dispose() {
    _queue.clear();
    final server = _server;
    _server = null;
    for (final waiter in _waiters) {
      if (!waiter.isCompleted) waiter.complete();
    }
    _waiters.clear();
    unawaited(server?.close(force: true));
  }
}
