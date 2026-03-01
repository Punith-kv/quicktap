import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../pos_controller.dart';
import '../widgets/amount_display.dart';
import '../widgets/big_primary_button.dart';
import '../widgets/connection_pill.dart';
import '../widgets/status_badge.dart';
import '../models/transaction.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickTap'),
        actions: [
          Consumer<PosController>(
            builder: (context, pos, _) => ConnectionPill(
              connected: pos.readerConnected,
              batteryPct: pos.readerBatteryPct,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<PosController>(
        builder: (context, pos, _) {
          final total = pos.todaysTotalPence;
          final last3 = pos.last3Transactions;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Today's total",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                AmountDisplay(amountPence: total),
                const SizedBox(height: 32),
                BigPrimaryButton(
                  text: 'Charge',
                  onPressed: () => context.push('/amount'),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Recent',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (last3.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No transactions yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ...last3.map((tx) => _TxTile(transaction: tx)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.point_of_sale),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        onDestinationSelected: (index) {
          if (index == 1) context.go('/history');
        },
      ),
    );
  }
}

class _TxTile extends StatelessWidget {
  final Transaction transaction;

  const _TxTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final method = transaction.method == PaymentMethod.card ? 'Card' : 'QR';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(AmountDisplay.formatPence(transaction.amountPence)),
        subtitle: Text('$method · ${transaction.reference}'),
        trailing: StatusBadge(status: transaction.status),
        onTap: () => context.push('/tx/${transaction.id}'),
      ),
    );
  }
}
