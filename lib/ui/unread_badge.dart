import 'package:flutter/material.dart';

import '../state/event_feed.dart';
import '../theme.dart';

class UnreadBadge extends StatelessWidget {
  const UnreadBadge({super.key, required this.feed});

  final DeviceFeed? feed;

  @override
  Widget build(BuildContext context) {
    final unread = feed?.unread ?? 0;
    if (unread <= 0) return const SizedBox.shrink();

    final alert = feed?.permPending ?? false;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: alert ? ZT.danger : ZT.accent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        unread >= 99 ? '99+' : '$unread',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: alert ? Colors.white : ZT.onAccent,
        ),
      ),
    );
  }
}
