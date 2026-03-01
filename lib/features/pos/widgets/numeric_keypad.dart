import 'package:flutter/material.dart';

class NumericKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyTap;

  const NumericKeypad({super.key, required this.onKeyTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = (constraints.maxWidth / 3) - 8;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _key('1', size),
            _key('2', size),
            _key('3', size),
            _key('4', size),
            _key('5', size),
            _key('6', size),
            _key('7', size),
            _key('8', size),
            _key('9', size),
            _key('.', size),
            _key('0', size),
            _key('⌫', size),
          ],
        );
      },
    );
  }

  Widget _key(String label, double size) {
    return SizedBox(
      width: size,
      height: 64,
      child: Material(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => onKeyTap(label),
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
