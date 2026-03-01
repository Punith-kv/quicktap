import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../pos_controller.dart';
import '../models/transaction.dart';
import '../widgets/amount_display.dart';
import '../widgets/big_primary_button.dart';

class MethodSelectScreen extends StatelessWidget {
  const MethodSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pos = context.read<PosController>();
    final amount = pos.pendingAmountPence;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment method'),
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
            const SizedBox(height: 16),
            Text(
              'Amount: ${AmountDisplay.formatPence(amount)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            BigPrimaryButton(
              text: 'Debit / Credit Card',
              onPressed: () {
                pos.selectMethod(PaymentMethod.card);
                context.push('/card-wait');
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: () {
                  pos.selectMethod(PaymentMethod.qr);
                  context.push('/qr');
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 64),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: const Text('QR Code'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
