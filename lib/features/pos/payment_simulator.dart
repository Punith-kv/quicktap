import 'dart:math';
import 'models/transaction.dart';

/// Simulated payment engine — no real APIs.
class PaymentSimulator {
  static final _rng = Random();

  /// Card: 2s delay, 90% approved.
  Future<TxStatus> simulateCard(int amountPence) async {
    await Future.delayed(const Duration(seconds: 2));
    return _rng.nextDouble() < 0.9 ? TxStatus.approved : TxStatus.declined;
  }

  /// QR: 1s delay, approved (or use force result for demo).
  Future<TxStatus> simulateQr(int amountPence) async {
    await Future.delayed(const Duration(seconds: 1));
    return TxStatus.approved;
  }

  /// Demo: force declined.
  Future<TxStatus> forceDeclined() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return TxStatus.declined;
  }

  /// Demo: force timeout.
  Future<TxStatus> forceTimeout() async {
    await Future.delayed(const Duration(seconds: 2));
    return TxStatus.failed; // use errorType: timeout in UI
  }

  /// Demo: force reader disconnected.
  Future<TxStatus> forceReaderDisconnected() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return TxStatus.failed; // use errorType: reader in UI
  }
}
