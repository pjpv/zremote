import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResumeReloadEpoch extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

final resumeReloadEpochProvider =
    NotifierProvider<ResumeReloadEpoch, int>(ResumeReloadEpoch.new);
