import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../pos_controller.dart';
import '../widgets/amount_display.dart';
import '../widgets/big_primary_button.dart';
import '../widgets/numeric_keypad.dart';

class AmountEntryScreen extends StatefulWidget {
  const AmountEntryScreen({super.key});

  @override
  State<AmountEntryScreen> createState() => _AmountEntryScreenState();
}

class _AmountEntryScreenState extends State<AmountEntryScreen> {
  String _input = '0';

  void _onKeyTap(String key) {
    setState(() {
      if (key == '⌫') {
        if (_input.length > 1) {
          _input = _input.substring(0, _input.length - 1);
        } else {
          _input = '0';
        }
      } else if (key == '.') {
        if (!_input.contains('.')) _input += '.';
      } else {
        if (_input == '0' && key != '0') _input = key;
        else if (_input != '0') _input += key;
      }
    });
  }

  int _getPence() {
    if (_input.contains('.')) {
      final parts = _input.split('.');
      final pounds = int.tryParse(parts[0]) ?? 0;
      final frac = parts[1].padRight(2, '0').substring(0, 2);
      final pence = int.tryParse(frac) ?? 0;
      return pounds * 100 + pence;
    }
    return (int.tryParse(_input) ?? 0) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter amount'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            AmountDisplay(amountPence: _getPence()),
            const SizedBox(height: 32),
            NumericKeypad(onKeyTap: _onKeyTap),
            const Spacer(),
            BigPrimaryButton(
              text: 'Charge',
              onPressed: () {
                final pence = _getPence();
                if (pence <= 0) return;
                context.read<PosController>().startCharge(pence);
                context.push('/method');
              },
            ),
          ],
        ),
      ),
    );
  }
}
