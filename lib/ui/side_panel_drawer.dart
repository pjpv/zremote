export 'toolbox_sheet.dart';

import 'package:flutter/material.dart';

import '../models/device.dart';
import 'toolbox_sheet.dart';

class SidePanelDrawer extends StatelessWidget {
  const SidePanelDrawer({
    super.key,
    required this.device,
    required this.onAutomationPressed,
    required this.onClaimPressed,
    required this.onUsagePressed,
  });

  final RemoteDevice device;
  final VoidCallback onAutomationPressed;
  final VoidCallback onClaimPressed;
  final VoidCallback onUsagePressed;

  @override
  Widget build(BuildContext context) {
    return ToolboxSheet(
      device: device,
      onAutomationPressed: onAutomationPressed,
      onClaimPressed: onClaimPressed,
      onUsagePressed: onUsagePressed,
    );
  }
}
