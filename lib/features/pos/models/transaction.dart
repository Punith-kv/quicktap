enum PaymentMethod { card, qr }

enum TxStatus { approved, declined, failed, refunded }

class Transaction {
  final String id;
  final DateTime createdAt;
  final int amountPence;
  final PaymentMethod method;
  TxStatus status;
  final String? last4;
  final String reference;

  Transaction({
    required this.id,
    required this.createdAt,
    required this.amountPence,
    required this.method,
    required this.status,
    this.last4,
    required this.reference,
  });

  bool get isRefunded => status == TxStatus.refunded;
  bool get isApproved => status == TxStatus.approved;
  bool get canRefund => isApproved && !isRefunded;
}
