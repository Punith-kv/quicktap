import 'package:flutter/material.dart';

class ConnectionPill extends StatelessWidget {
  final bool connected;
  final int batteryPct;

  const ConnectionPill({
    super.key,
    required this.connected,
    this.batteryPct = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: connected
            ? Colors.green.withValues(alpha: 0.15)
            : Colors.orange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: connected ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            connected ? Icons.nfc : Icons.nfc_outlined,
            size: 18,
            color: connected ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 6),
          Text(
            connected ? 'Reader $batteryPct%' : 'Disconnected',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: connected ? Colors.green.shade800 : Colors.orange.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
