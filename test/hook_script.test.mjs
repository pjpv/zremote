import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import vm from 'node:vm';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const dartSrc = readFileSync(
  path.join(repoRoot, 'lib', 'services', 'event_observer.dart'),
  'utf8',
);
const declAt = dartSrc.indexOf('static String hookScriptFor');
assert.ok(declAt >= 0, 'hookScriptFor 声明定位失败');
const beginMarker = "'''";
const begin = dartSrc.indexOf(beginMarker, declAt);
const end = dartSrc.lastIndexOf("''';");
assert.ok(begin >= 0 && end > begin, 'hookScript 脚本定位失败');
const maxBytes = Number(
  /const int kMaxListenBytes = (\d+);/.exec(dartSrc)[1],
);
assert.ok(Number.isFinite(maxBytes), 'kMaxListenBytes 解析失败');
const dispatchPort = 47832;
const dispatchToken = 'ab12cd34';
const hookSource = dartSrc
  .slice(begin + beginMarker.length, end)
  .replaceAll('$kMaxListenBytes', String(maxBytes))
  .replaceAll('$dispatchPort', String(dispatchPort))
  .replaceAll('$dispatchToken', dispatchToken);

const svcCalls = [];
const zcodeAgentService = {
  listAllAutomations: () => Promise.resolve([{ automationId: 'a1' }]),
  setAutomationEnabled: (p) => {
    svcCalls.push(['setAutomationEnabled', p]);
    return Promise.resolve({ updated: true });
  },
  boom: () => Promise.reject(new Error('Provided value cannot be bound to SQLite parameter 4.')),
};
const offPeakTaskService = {
  list: () => Promise.resolve([{ offPeakTaskId: 't1' }]),
  pauseTask: (id) => {
    svcCalls.push(['pauseTask', id]);
    return Promise.resolve(null);
  },
};
let container = {
  fileService: {},
  gitService: {},
  systemService: {},
  terminalService: {},
  credentialService: {},
  broadcastService: {},
  zcodeTaskService: {},
  windowControllerService: {},
  modelProviderService: {},
  settingService: {},
  zcodeAgentService,
  offPeakTaskService,
};
const providerFiber = {
  memoizedProps: { ctx: { value: container } },
  memoizedState: null,
  stateNode: null,
  child: null,
  sibling: null,
  return: null,
};
const anchorFiber = {
  memoizedProps: null,
  memoizedState: null,
  stateNode: null,
  child: null,
  sibling: null,
  return: providerFiber,
};
const domEl = { __reactFiber$abc123: anchorFiber };
let domEls = [domEl];
let domBroken = false;

const handlerCalls = [];
const fakeWindow = {
  addEventListener() {},
  flutter_inappwebview: {
    callHandler(name, body) {
      handlerCalls.push({ name, body });
    },
  },
};
class FakeWS {
  constructor(url) {
    this.url = String(url);
    this.readyState = 0;
    this.listeners = {};
  }
  addEventListener(type, fn) {
    (this.listeners[type] ??= []).push(fn);
  }
  fire(type, ev) {
    for (const fn of this.listeners[type] ?? []) fn(ev ?? {});
  }
  send(d) {
    this.lastSent = d;
  }
  open() {
    this.readyState = 1;
    this.fire('open');
  }
  close() {
    if (this.readyState === 3) return;
    this.readyState = 3;
    this.fire('close', { code: 1006, reason: '' });
  }
  message(d) {
    this.fire('message', { data: d });
  }
}
fakeWindow.WebSocket = FakeWS;

const fetchCalls = [];
const fetchScript = [];
const timerCallbacks = [];
const never = new Promise(() => {});
const fetchImpl = (url) => {
  fetchCalls.push(String(url));
  const next = fetchScript.length ? fetchScript.shift() : null;
  if (!next) return never;
  if (next.reject) return Promise.reject(next.reject);
  return Promise.resolve({
    ok: next.ok ?? true,
    json: next.json ?? (() => Promise.resolve({ c: [] })),
  });
};
const setTimeoutImpl = (fn) => {
  timerCallbacks.push(fn);
  return 0;
};
fetchScript.push({ reject: new Error('first boot') });

const sandbox = {
  window: fakeWindow,
  document: {
    querySelectorAll: () => (domBroken ? [] : domEls),
    getElementById: () => null,
    createElement: () => ({ style: {}, id: '', src: '' }),
    body: { appendChild() {} },
    head: { appendChild() {} },
  },
  Node: function FakeNode() {},
  setInterval: () => 0,
  clearInterval: () => {},
  setTimeout: setTimeoutImpl,
  clearTimeout: () => {},
  fetch: fetchImpl,
  atob: (s) => Buffer.from(s, 'base64').toString('binary'),
  btoa: (s) => Buffer.from(s, 'binary').toString('base64'),
  TextDecoder,
  console,
};
vm.createContext(sandbox);
vm.runInContext(hookSource, sandbox, { filename: 'hookScript.generated.js' });

const callsNamed = (name) => handlerCalls.filter((c) => c.name === name);
const lastSvcResult = () => JSON.parse(callsNamed('zrSvcResult').at(-1).body);
const tick = () => new Promise((r) => setTimeout(r, 0));
const b64 = (v) => Buffer.from(JSON.stringify(v), 'utf8').toString('base64');

assert.equal(typeof sandbox.window.__zrSvcCall, 'function');
assert.equal(typeof sandbox.window.__zrRpcCall, 'undefined');

assert.equal(
  sandbox.window.__zrSvcCall(1, 'zcodeAgentService', 'listAllAutomations', ''),
  'queued',
);
await tick();
let res = lastSvcResult();
assert.equal(res.i, 1);
assert.equal(res.ok, true);
assert.deepEqual(JSON.parse(res.r), [{ automationId: 'a1' }]);

const params = { automationId: "it's 中文『关机』🀄", enabled: false };
assert.equal(
  sandbox.window.__zrSvcCall(2, 'zcodeAgentService', 'setAutomationEnabled', b64([params])),
  'queued',
);
await tick();
assert.equal(JSON.stringify(svcCalls[0]), JSON.stringify(['setAutomationEnabled', params]));
res = lastSvcResult();
assert.equal(res.i, 2);
assert.deepEqual(JSON.parse(res.r), { updated: true });

assert.equal(
  sandbox.window.__zrSvcCall(3, 'offPeakTaskService', 'pauseTask', b64(['t9'])),
  'queued',
);
await tick();
assert.equal(JSON.stringify(svcCalls[1]), JSON.stringify(['pauseTask', 't9']));
res = lastSvcResult();
assert.equal(res.i, 3);
assert.equal(res.ok, true);
assert.equal(res.r, 'null');

sandbox.window.__zrSvcCall(4, 'zcodeAgentService', 'boom', '');
await tick();
res = lastSvcResult();
assert.equal(res.i, 4);
assert.equal(res.ok, false);
assert.match(res.e, /SQLite parameter 4/);

sandbox.window.__zrSvcCall(5, 'zcodeAgentService', 'nope', '');
await tick();
assert.equal(lastSvcResult().e, 'no-method');

container.zcodeAgentService = {};
domBroken = true;
sandbox.window.__zrSvcCall(6, 'zcodeAgentService', 'listAllAutomations', '');
await tick();
assert.equal(lastSvcResult().e, 'no-services');
domBroken = false;

const fresh = {
  ...container,
  zcodeAgentService: { listAllAutomations: () => Promise.resolve([{ automationId: 'fresh' }]) },
};
providerFiber.memoizedProps = { ctx: { value: fresh } };
sandbox.window.__zrSvcCall(7, 'zcodeAgentService', 'listAllAutomations', '');
await tick();
res = lastSvcResult();
assert.equal(res.i, 7);
assert.deepEqual(JSON.parse(res.r), [{ automationId: 'fresh' }]);

const ws = new fakeWindow.WebSocket('wss://zcode.z.ai/ws?mid=u1');
ws.open();
ws.close();
const wsEvents = callsNamed('zrWs').map((c) => JSON.parse(c.body));
assert.equal(wsEvents.filter((e) => e.s === 'open').length, 1);
assert.equal(wsEvents.filter((e) => e.s === 'closed').length, 1);
assert.equal(ws.send, FakeWS.prototype.send);

assert.equal(fetchCalls.length, 1);
assert.equal(fetchCalls[0], 'http://127.0.0.1:' + dispatchPort + '/zrp/' + dispatchToken);
assert.equal(timerCallbacks.length, 1);
const cmd41 = { i: 41, s: 'zcodeAgentService', m: 'listAllAutomations', a: '' };
fetchScript.push({ json: () => Promise.resolve({ c: [cmd41] }) });
ws.message('{}');
assert.equal(fetchCalls.length, 2);
await tick();
res = lastSvcResult();
assert.equal(res.i, 41);
assert.deepEqual(JSON.parse(res.r), [{ automationId: 'fresh' }]);
assert.equal(fetchCalls.length, 3);
assert.equal(
  sandbox.window.__zrSvcCall(41, 'zcodeAgentService', 'listAllAutomations', ''),
  'dup',
);
await tick();
assert.equal(lastSvcResult().i, 41);
assert.equal(
  callsNamed('zrSvcResult').filter((c) => JSON.parse(c.body).i === 41).length,
  1,
);

const probeB64 = b64([
  [
    { s: 'zcodeAgentService', m: ['listAllAutomations', 'nope'] },
    { s: 'ghostService', m: ['x'] },
  ],
]);
sandbox.window.__zrSvcCall(60, '__zrProbe', 'dump', probeB64);
assert.equal(sandbox.window.__zrSvcCall(60, '__zrProbe', 'dump', probeB64), 'dup');
await tick();
let probeRes = lastSvcResult();
assert.equal(probeRes.i, 60);
assert.equal(probeRes.ok, true);
const dump = JSON.parse(probeRes.r);
assert.deepEqual(dump.checks, {
  'zcodeAgentService.listAllAutomations': true,
  'zcodeAgentService.nope': false,
  'ghostService.x': 'no-svc',
});
assert.ok(Array.isArray(dump.keys) && dump.keys.includes('zcodeAgentService'));
assert.ok(dump.keys.includes('offPeakTaskService'));
assert.ok(!dump.keys.includes('__zrProbe'));

sandbox.window.__zrSvcCall(61, '__zrProbe', 'nonsense', '');
await tick();
assert.equal(lastSvcResult().i, 61);
assert.equal(lastSvcResult().e, 'no-method');

assert.equal(
  sandbox.window.__zrSvcCall(63, 'zcodeAgentService', 'listAllAutomations', b64([])),
  'queued',
);
await tick();
probeRes = lastSvcResult();
assert.equal(probeRes.i, 63);
assert.equal(probeRes.ok, true);
assert.deepEqual(JSON.parse(probeRes.r), [{ automationId: 'fresh' }]);

fresh.zcodeAgentService = {};
domBroken = true;
sandbox.window.__zrSvcCall(64, '__zrProbe', 'dump', '');
await tick();
assert.equal(lastSvcResult().i, 64);
assert.equal(lastSvcResult().e, 'no-services');

const captchaCalls = [];
let captchaHandlers = null;
fakeWindow.initAliyunCaptcha = (opts) => {
  captchaCalls.push(opts);
  captchaHandlers = opts;
};

assert.equal(
  sandbox.window.__zrSvcCall(51, '__zrCaptcha', 'verify', b64([{ sceneId: 'x', region: 'cn', prefix: 'p', timeoutMs: 8000 }])),
  'queued',
);
await tick();
assert.equal(captchaCalls.length, 1);
assert.equal(captchaCalls[0].SceneId, 'x');
assert.equal(captchaCalls[0].mode, 'popup');
assert.equal(captchaCalls[0].language, 'zh-CN');
assert.equal(captchaCalls[0].showErrorTip, false);
assert.equal(captchaCalls[0].element, '#zr-cap-holder');
assert.equal(captchaCalls[0].button, '#zr-cap-btn');
assert.equal(JSON.stringify(fakeWindow.AliyunCaptchaConfig), JSON.stringify({ region: 'cn', prefix: 'p' }));
captchaHandlers.success('abc');
await tick();
res = lastSvcResult();
assert.equal(res.i, 51);
assert.equal(res.ok, true);
assert.equal(res.r, '{"ok":true,"param":"abc"}');

fakeWindow.initAliyunCaptcha = (opts) => {
  captchaCalls.push(opts);
  captchaHandlers = opts;
};
assert.equal(
  sandbox.window.__zrSvcCall(52, '__zrCaptcha', 'verify', b64([{ sceneId: 'y', timeoutMs: 5000 }])),
  'queued',
);
assert.equal(sandbox.window.__zrSvcCall(53, '__zrCaptcha', 'verify', ''), 'queued');
await tick();
res = lastSvcResult();
assert.equal(res.i, 53);
assert.equal(res.ok, false);
assert.equal(res.e, 'captcha-busy');
timerCallbacks.at(-1)();
await tick();
res = lastSvcResult();
assert.equal(res.i, 52);
assert.equal(res.ok, true);
assert.equal(JSON.parse(res.r).reason, 'timeout');
assert.equal(
  sandbox.window.__zrSvcCall(54, '__zrCaptcha', 'verify', b64([{ sceneId: 'z' }])),
  'queued',
);
captchaHandlers.success('p54');
await tick();
res = lastSvcResult();
assert.equal(res.i, 54);
assert.equal(JSON.parse(res.r).param, 'p54');

assert.equal(
  sandbox.window.__zrSvcCall(55, '__zrCaptcha', 'verify', b64([{ sceneId: 'w' }])),
  'queued',
);
assert.equal(
  sandbox.window.__zrSvcCall(55, '__zrCaptcha', 'verify', b64([{ sceneId: 'w' }])),
  'dup',
);
captchaHandlers.success('p55');
await tick();
assert.equal(
  callsNamed('zrSvcResult').filter((c) => JSON.parse(c.body).i === 55).length,
  1,
);
assert.equal(JSON.parse(callsNamed('zrSvcResult').at(-1).body).i, 55);

console.log('hookScript 语义测试全部通过（17 场景）');
