import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../pos_controller.dart';
import '../models/transaction.dart';
import '../widgets/state_screen.dart';

/// Processing: locked; show Cancel only after 15s.
class ProcessingScreen extends StatefulWidget {
  final String method; // card | qr
  final bool forceDecline;
  final bool forceTimeout;
  final bool forceReaderDisconnected;

  const ProcessingScreen({
    super.key,
    required this.method,
    this.forceDecline = false,
    this.forceTimeout = false,
    this.forceReaderDisconnected = false,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  static const _cancelAfterSec = 15;
  Timer? _cancelTimer;
  Timer? _stageTimer;
  bool _showCancel = false;
  int _stage = 0;

  static const _cardStages = ['Reading card…', 'Authorising…', 'Finalising…'];
  static const _qrStages = ['Confirming payment…', 'Finalising…'];

  @override
  void initState() {
    super.initState();
    _cancelTimer = Timer(const Duration(seconds: _cancelAfterSec), () {
      if (mounted) setState(() => _showCancel = true);
    });
    _stageTimer = Timer.periodic(const Duration(milliseconds: 700), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      final stages = widget.method == 'card' ? _cardStages : _qrStages;
      setState(() => _stage = (_stage + 1) % stages.length);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _runPayment());
  }

  Future<void> _runPayment() async {
    final pos = context.read<PosController>();
    final isCard = widget.method == 'card';
    TxStatus status;
    if (isCard) {
      status = await pos.simulateCardPayment(
        forceDecline: widget.forceDecline,
        forceTimeout: widget.forceTimeout,
        forceReaderOff: widget.forceReaderDisconnected,
      );
    } else {
      status = await pos.simulateQrPayment();
    }
    if (!mounted) return;
    _cancelTimer?.cancel();
    final success = status == TxStatus.approved;
    String errorType = '';
    if (!success) {
      if (status == TxStatus.declined) errorType = 'declined';
      else if (widget.forceReaderDisconnected) errorType = 'readerDisconnected';
      else errorType = 'timeout';
    }
    context.go('/result?success=$success&error=$errorType');
  }

  @override
  void dispose() {
    _cancelTimer?.cancel();
    _stageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stages = widget.method == 'card' ? _cardStages : _qrStages;
    final subtitle = stages[_stage.clamp(0, stages.length - 1)];
    return StateScreen(
      backgroundColor: const Color(0xFF37474F),
      icon: Icons.hourglass_empty,
      title: 'Processing…',
      subtitle: subtitle,
      secondaryButtonLabel: _showCancel ? 'Cancel' : null,
      secondaryButtonOnPressed:
          _showCancel ? () => context.go('/') : null,
    );
  }
}
