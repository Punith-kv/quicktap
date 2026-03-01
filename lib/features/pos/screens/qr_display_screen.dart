import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../pos_controller.dart';
import '../widgets/amount_display.dart';
import '../widgets/big_primary_button.dart';

/// QR display: 5 min timer → expired error + regenerate.
class QrDisplayScreen extends StatefulWidget {
  const QrDisplayScreen({super.key});

  @override
  State<QrDisplayScreen> createState() => _QrDisplayScreenState();
}

class _QrDisplayScreenState extends State<QrDisplayScreen> {
  static const _expirySec = 5 * 60; // 5 minutes
  Timer? _expiryTimer;
  int _remainingSec = _expirySec;
  bool _expired = false;

  @override
  void initState() {
    super.initState();
    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remainingSec--;
        if (_remainingSec <= 0) {
          _expired = true;
          _expiryTimer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    super.dispose();
  }

  void _onSimulatePaid() {
    if (_expired) return;
    _expiryTimer?.cancel();
    context.push('/processing?method=qr');
  }

  void _onRegenerate() {
    _expiryTimer?.cancel();
    context.go('/qr');
  }

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final amount = pos.pendingAmountPence;
    final min = _remainingSec ~/ 60;
    final sec = _remainingSec % 60;

    if (_expired) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.schedule, size: 64, color: Colors.orange),
                const SizedBox(height: 24),
                Text(
                  'QR timed out',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  "No charge made. I'll generate a new code.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                BigPrimaryButton(
                  text: 'Regenerate',
                  onPressed: _onRegenerate,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Back to Home'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan to pay'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              AmountDisplay.formatPence(amount),
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Expires in ${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: _remainingSec <= 60 ? Colors.red : Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: QrImageView(
                data: 'quicktap://pay?amount=$amount&ts=${DateTime.now().millisecondsSinceEpoch}',
                version: QrVersions.auto,
                size: 220,
              ),
            ),
            const Spacer(),
            BigPrimaryButton(
              text: 'Simulate paid',
              onPressed: _onSimulatePaid,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => context.go('/result?success=false&error=qrExpired'),
              icon: const Icon(Icons.schedule, size: 18),
              label: const Text('Demo: Force QR expired'),
            ),
          ],
        ),
      ),
    );
  }
}
