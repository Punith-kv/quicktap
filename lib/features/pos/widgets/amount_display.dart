import 'package:flutter/material.dart';

class AmountDisplay extends StatelessWidget {
  final int amountPence;

  const AmountDisplay({super.key, required this.amountPence});

  static String formatPence(int pence) {
    final pounds = pence ~/ 100;
    final p = pence % 100;
    return '£$pounds.${p.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatPence(amountPence),
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
          ) ??
          const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
    );
  }
}
