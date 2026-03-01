import 'package:flutter/material.dart';
import 'big_primary_button.dart';

class StateScreen extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? primaryButtonLabel;
  final VoidCallback? primaryButtonOnPressed;
  final String? secondaryButtonLabel;
  final VoidCallback? secondaryButtonOnPressed;

  const StateScreen({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.title,
    this.subtitle,
    this.primaryButtonLabel,
    this.primaryButtonOnPressed,
    this.secondaryButtonLabel,
    this.secondaryButtonOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Icon(icon, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                ),
              ],
              const Spacer(flex: 2),
              if (primaryButtonLabel != null && primaryButtonOnPressed != null)
                BigPrimaryButton(
                  text: primaryButtonLabel!,
                  onPressed: primaryButtonOnPressed,
                ),
              if (secondaryButtonLabel != null &&
                  secondaryButtonOnPressed != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: secondaryButtonOnPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                    child: Text(secondaryButtonLabel!),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
