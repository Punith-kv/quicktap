import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../pos_controller.dart';
import '../widgets/amount_display.dart';
import '../widgets/state_screen.dart';

/// Card wait: 30s timeout → "No card detected…"
class CardWaitScreen extends StatefulWidget {
  const CardWaitScreen({super.key});

  @override
  State<CardWaitScreen> createState() => _CardWaitScreenState();
}

class _CardWaitScreenState extends State<CardWaitScreen> {
  Timer? _timeoutTimer;
  static const _timeoutSec = 30;
  bool _demoExpanded = false;

  @override
  void initState() {
    super.initState();
    _timeoutTimer = Timer(const Duration(seconds: _timeoutSec), () {
      if (!mounted) return;
      context.go('/result?success=false&error=cardTimeout');
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _onCardDetected() {
    _timeoutTimer?.cancel();
    context.push('/processing?method=card');
  }

  void _forceError(String force) {
    _timeoutTimer?.cancel();
    context.push('/processing?method=card&force=$force');
  }

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final amount = pos.pendingAmountPence;

    return Scaffold(
      body: Stack(
        children: [
          StateScreen(
            backgroundColor: const Color(0xFF1565C0),
            icon: Icons.credit_card,
            title: 'Tap or insert card',
            subtitle: AmountDisplay.formatPence(amount),
            primaryButtonLabel: 'Card detected',
            primaryButtonOnPressed: _onCardDetected,
            secondaryButtonLabel: 'Cancel',
            secondaryButtonOnPressed: () {
              _timeoutTimer?.cancel();
              context.go('/');
            },
          ),
          // Demo toggle — top-right
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: Material(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => setState(() => _demoExpanded = !_demoExpanded),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Demo', style: TextStyle(color: Colors.white, fontSize: 12)),
                      Icon(
                        _demoExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_demoExpanded)
            Positioned(
              top: MediaQuery.of(context).padding.top + 48,
              right: 16,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                        onPressed: () => _forceError('declined'),
                        child: const Text('Force decline'),
                      ),
                      TextButton(
                        onPressed: () => _forceError('timeout'),
                        child: const Text('Force timeout'),
                      ),
                      TextButton(
                        onPressed: () => _forceError('readerDisconnected'),
                        child: const Text('Force reader disconnected'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
