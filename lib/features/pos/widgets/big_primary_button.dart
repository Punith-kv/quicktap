import 'package:flutter/material.dart';

class BigPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const BigPrimaryButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
