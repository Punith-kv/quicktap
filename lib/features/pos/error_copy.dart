/// Error type for result screen (not TxStatus).
enum ResultErrorType { declined, timeout, readerDisconnected, qrExpired, cardTimeout }

class ErrorCopy {
  final String headline;
  final String speakableLine;
  final String primaryAction;
  final String? secondaryAction;

  const ErrorCopy({
    required this.headline,
    required this.speakableLine,
    required this.primaryAction,
    this.secondaryAction,
  });

  static ErrorCopy forType(ResultErrorType type) {
    switch (type) {
      case ResultErrorType.declined:
        return const ErrorCopy(
          headline: 'Card declined',
          speakableLine: 'Could you try another card or tap again?',
          primaryAction: 'Retry',
          secondaryAction: 'Switch to QR',
        );
      case ResultErrorType.timeout:
        return const ErrorCopy(
          headline: 'Took too long',
          speakableLine: "Let's try again — connection was slow.",
          primaryAction: 'Retry',
          secondaryAction: 'Back to Home',
        );
      case ResultErrorType.cardTimeout:
        return const ErrorCopy(
          headline: 'No card detected',
          speakableLine: "The reader didn't detect a card. Try tapping or inserting again.",
          primaryAction: 'Retry',
          secondaryAction: 'Back to Home',
        );
      case ResultErrorType.readerDisconnected:
        return const ErrorCopy(
          headline: 'Reader not connected',
          speakableLine: 'One moment — reconnecting the reader.',
          primaryAction: 'Retry',
          secondaryAction: 'Use QR',
        );
      case ResultErrorType.qrExpired:
        return const ErrorCopy(
          headline: 'QR timed out',
          speakableLine: "No charge made. I'll generate a new code.",
          primaryAction: 'Regenerate',
          secondaryAction: 'Back to Home',
        );
    }
  }
}
