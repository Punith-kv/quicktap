import 'package:flutter/foundation.dart';
import 'models/transaction.dart';
import 'payment_simulator.dart';

class PosController extends ChangeNotifier {
  final PaymentSimulator _simulator = PaymentSimulator();

  final List<Transaction> _transactions = [];
  List<Transaction> get transactions => List.unmodifiable(_transactions);

  int _todaysTotalPence = 0;
  int get todaysTotalPence => _todaysTotalPence;

  bool _readerConnected = true;
  bool get readerConnected => _readerConnected;
  int _readerBatteryPct = 100;
  int get readerBatteryPct => _readerBatteryPct;

  int _pendingAmountPence = 0;
  PaymentMethod? _pendingMethod;
  int get pendingAmountPence => _pendingAmountPence;
  PaymentMethod? get pendingMethod => _pendingMethod;

  List<Transaction> get last3Transactions =>
      _transactions.take(3).toList();

  static int _todayStart(DateTime d) {
    return DateTime(d.year, d.month, d.day).millisecondsSinceEpoch;
  }

  int get todaysTotalFromTransactions {
    final start = _todayStart(DateTime.now());
    return _transactions
        .where((t) => t.createdAt.millisecondsSinceEpoch >= start)
        .where((t) => t.status == TxStatus.approved)
        .fold<int>(0, (s, t) => s + t.amountPence)
        - _transactions
            .where((t) => t.createdAt.millisecondsSinceEpoch >= start)
            .where((t) => t.status == TxStatus.refunded)
            .fold<int>(0, (s, t) => s + t.amountPence);
  }

  void startCharge(int amountPence) {
    _pendingAmountPence = amountPence;
    _pendingMethod = null;
    notifyListeners();
  }

  void selectMethod(PaymentMethod method) {
    _pendingMethod = method;
    notifyListeners();
  }

  Future<TxStatus> simulateCardPayment({bool forceDecline = false, bool forceTimeout = false, bool forceReaderOff = false}) async {
    _pendingMethod = PaymentMethod.card;
    TxStatus status;
    if (forceDecline) {
      status = await _simulator.forceDeclined();
    } else if (forceTimeout) {
      status = await _simulator.forceTimeout();
    } else if (forceReaderOff) {
      status = await _simulator.forceReaderDisconnected();
    } else {
      status = await _simulator.simulateCard(_pendingAmountPence);
    }
    if (status == TxStatus.approved) {
      _addTransaction(TxStatus.approved);
    }
    notifyListeners();
    return status;
  }

  Future<TxStatus> simulateQrPayment({bool forceExpired = false}) async {
    _pendingMethod = PaymentMethod.qr;
    if (forceExpired) {
      await Future.delayed(const Duration(milliseconds: 300));
      notifyListeners();
      return TxStatus.failed; // UI maps to QR expired
    }
    final status = await _simulator.simulateQr(_pendingAmountPence);
    if (status == TxStatus.approved) {
      _addTransaction(TxStatus.approved);
    }
    notifyListeners();
    return status;
  }

  void _addTransaction(TxStatus status) {
    final id = 'tx_${DateTime.now().millisecondsSinceEpoch}';
    final ref = 'QT${DateTime.now().millisecondsSinceEpoch % 100000}';
    final tx = Transaction(
      id: id,
      createdAt: DateTime.now(),
      amountPence: _pendingAmountPence,
      method: _pendingMethod ?? PaymentMethod.card,
      status: status,
      last4: _pendingMethod == PaymentMethod.card ? '4242' : null,
      reference: ref,
    );
    _transactions.insert(0, tx);
    _todaysTotalPence = todaysTotalFromTransactions;
    notifyListeners();
  }

  void addTransaction(Transaction tx) {
    _transactions.insert(0, tx);
    _todaysTotalPence = todaysTotalFromTransactions;
    notifyListeners();
  }

  Transaction? getTransaction(String id) {
    try {
      return _transactions.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void refundTransaction(String id) {
    final tx = getTransaction(id);
    if (tx == null || !tx.canRefund) return;
    tx.status = TxStatus.refunded;
    _todaysTotalPence = todaysTotalFromTransactions;
    notifyListeners();
  }

  List<Transaction> transactionsFiltered({bool todayOnly = false, bool weekOnly = false}) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = now.subtract(const Duration(days: 7));
    if (todayOnly) {
      return _transactions.where((t) => t.createdAt.isAfter(todayStart) || t.createdAt.isAtSameMomentAs(todayStart)).toList();
    }
    if (weekOnly) {
      return _transactions.where((t) => t.createdAt.isAfter(weekStart)).toList();
    }
    return _transactions;
  }

  void setReaderConnected(bool connected) {
    _readerConnected = connected;
    notifyListeners();
  }

  void setReaderBattery(int pct) {
    _readerBatteryPct = pct.clamp(0, 100);
    notifyListeners();
  }
}
