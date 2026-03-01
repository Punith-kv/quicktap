import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../pos_controller.dart';
import '../models/transaction.dart';
import '../widgets/amount_display.dart';
import '../widgets/big_primary_button.dart';
import '../widgets/status_badge.dart';

class TransactionDetailScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosController>();
    final tx = pos.getTransaction(transactionId);

    if (tx == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction')),
        body: const Center(child: Text('Transaction not found')),
      );
    }

    final method = tx.method == PaymentMethod.card ? 'Card' : 'QR';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AmountDisplay(amountPence: tx.amountPence),
            const SizedBox(height: 8),
            StatusBadge(status: tx.status),
            const SizedBox(height: 24),
            _row('Reference', tx.reference),
            _row('Method', method),
            _row('Date', _formatDateTime(tx.createdAt)),
            if (tx.last4 != null) _row('Card', '•••• ${tx.last4}'),
            const Spacer(),
            if (tx.canRefund)
              BigPrimaryButton(
                text: 'Refund',
                onPressed: () => _showRefundConfirm(context, pos, tx),
              ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime d) {
    return '${d.day}/${d.month}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  void _showRefundConfirm(
      BuildContext context, PosController pos, Transaction tx) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => RefundConfirmSheet(
        transaction: tx,
        onConfirm: () {
          pos.refundTransaction(tx.id);
          Navigator.of(ctx).pop();
          context.pop(); // back to history
        },
        onCancel: () => Navigator.of(ctx).pop(),
      ),
    );
  }
}

class RefundConfirmSheet extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const RefundConfirmSheet({
    super.key,
    required this.transaction,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Refund ${AmountDisplay.formatPence(transaction.amountPence)}?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'This will mark the transaction as refunded and update today\'s total.',
            ),
            const SizedBox(height: 24),
            BigPrimaryButton(text: 'Confirm refund', onPressed: onConfirm),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onCancel,
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
