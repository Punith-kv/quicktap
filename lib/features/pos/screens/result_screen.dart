import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../error_copy.dart';
import '../widgets/state_screen.dart';

class ResultScreen extends StatelessWidget {
  final bool success;
  final String? errorType; // declined | timeout | readerDisconnected | qrExpired | cardTimeout

  const ResultScreen({
    super.key,
    required this.success,
    this.errorType,
  });

  static ResultErrorType? _parseError(String? e) {
    if (e == null || e.isEmpty) return null;
    switch (e) {
      case 'declined':
        return ResultErrorType.declined;
      case 'timeout':
        return ResultErrorType.timeout;
      case 'readerDisconnected':
        return ResultErrorType.readerDisconnected;
      case 'qrExpired':
        return ResultErrorType.qrExpired;
      case 'cardTimeout':
        return ResultErrorType.cardTimeout;
      default:
        return ResultErrorType.timeout;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (success) {
      return StateScreen(
        backgroundColor: Colors.green.shade700,
        icon: Icons.check_circle,
        title: 'Payment successful',
        subtitle: 'You can hand the receipt to the customer.',
        primaryButtonLabel: 'Done',
        primaryButtonOnPressed: () => context.go('/'),
      );
    }

    final err = _parseError(errorType) ?? ResultErrorType.timeout;
    final copy = ErrorCopy.forType(err);

    return StateScreen(
      backgroundColor: Colors.orange.shade800,
      icon: Icons.info_outline,
      title: copy.headline,
      subtitle: copy.speakableLine,
      primaryButtonLabel: copy.primaryAction,
      primaryButtonOnPressed: () {
        if (err == ResultErrorType.qrExpired) {
          context.go('/qr'); // Regenerate
        } else if (err == ResultErrorType.declined || err == ResultErrorType.cardTimeout || err == ResultErrorType.timeout) {
          context.go('/method'); // Retry or switch method
        } else {
          context.go('/method');
        }
      },
      secondaryButtonLabel: copy.secondaryAction,
      secondaryButtonOnPressed: () => context.go('/'),
    );
  }
}
