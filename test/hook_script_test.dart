import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'hookScript JS 语义（Node vm 驱动）：17 场景全过',
    () async {
      try {
        await Process.run('node', ['--version']);
      } on ProcessException {
        return;
      }
      final script = '${Directory.current.path}/test/hook_script.test.mjs';
      final result = await Process.run('node', [script]);
      expect(
        result.exitCode,
        0,
        reason: 'stdout: ${result.stdout}\nstderr: ${result.stderr}',
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
