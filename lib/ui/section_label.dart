import 'package:flutter/material.dart';

import '../theme.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 4),
      child: Text(
        text,
        style: zrMono(
          fontSize: 11,
          weight: FontWeight.w600,
          color: context.zt.textLo,
        ).copyWith(height: 1.1),
      ),
    );
  }
}
