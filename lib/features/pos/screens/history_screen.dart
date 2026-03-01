import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../pos_controller.dart';
import '../models/transaction.dart';
import '../widgets/amount_display.dart';
import '../widgets/status_badge.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _todayOnly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Consumer<PosController>(
        builder: (context, pos, _) {
          final list = pos.transactionsFiltered(
            todayOnly: _todayOnly,
            weekOnly: !_todayOnly,
          );
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Today'),
                      selected: _todayOnly,
                      onSelected: (_) => setState(() => _todayOnly = true),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Week'),
                      selected: !_todayOnly,
                      onSelected: (_) => setState(() => _todayOnly = false),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: list.isEmpty
                    ? const Center(
                        child: Text('No transactions'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          final tx = list[i];
                          final method =
                              tx.method == PaymentMethod.card ? 'Card' : 'QR';
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(
                                AmountDisplay.formatPence(tx.amountPence),
                              ),
                              subtitle: Text(
                                '$method · ${tx.reference} · ${_formatDate(tx.createdAt)}',
                              ),
                              trailing: StatusBadge(status: tx.status),
                              onTap: () =>
                                  context.push('/tx/${tx.id}'),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
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
          if (index == 0) context.go('/');
        },
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    if (d.day == now.day && d.month == now.month && d.year == now.year) {
      return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    }
    return '${d.day}/${d.month}/${d.year}';
  }
}
