import 'package:flutter/material.dart';
import '../models/transaction.dart';

class StatusBadge extends StatelessWidget {
  final TxStatus status;

  const StatusBadge({super.key, required this.status});

  static String label(TxStatus s) {
    switch (s) {
      case TxStatus.approved:
        return 'Approved';
      case TxStatus.declined:
        return 'Declined';
      case TxStatus.failed:
        return 'Failed';
      case TxStatus.refunded:
        return 'Refunded';
    }
  }

  static Color color(TxStatus s) {
    switch (s) {
      case TxStatus.approved:
        return Colors.green;
      case TxStatus.declined:
        return Colors.red;
      case TxStatus.failed:
        return Colors.orange;
      case TxStatus.refunded:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color(status).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color(status), width: 1),
      ),
      child: Text(
        label(status),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color(status).withValues(alpha: 0.9),
        ),
      ),
    );
  }
}
