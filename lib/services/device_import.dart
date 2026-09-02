import '../models/device.dart';

RemoteDevice? findDuplicateBySid(
  List<RemoteDevice> existing,
  RemoteDevice candidate,
) {
  if (candidate.sid.isEmpty) return null;
  for (final d in existing) {
    if (d.sid == candidate.sid) return d;
  }
  return null;
}

RemoteDevice? findDuplicateBySidExcept(
  List<RemoteDevice> existing,
  RemoteDevice candidate,
  String selfId,
) => findDuplicateBySid(
  [for (final d in existing) if (d.id != selfId) d],
  candidate,
);
