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
