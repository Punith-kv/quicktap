# QuickTap — POS Payment App Prototype

QuickTap is a clickable POS payment app prototype designed for small merchants and cashiers.

The focus is on **UI/UX and basic app logic only** — no real payments, no backend, and no external integrations.

A short design and research document (**QuickTap_Design_and_Research**) explaining the product decisions behind QuickTap is included in `/docs` for reference.

---

## What this is

- Clickable Flutter prototype
- Demonstrates the core POS payment flow
- Designed for merchant use under pressure
- Debit card and QR payment (simulated)
- Clear success and error states
- Transaction history and refunds

---

## What this is NOT

- No real payment processing
- No backend services
- No external APIs
- No production integrations

All payment behavior is simulated in-app.

---

## Core flows

- Home → Charge → Amount → Card / QR → Processing → Success / Error
- Transaction history (Today / Week)
- Refund flow with confirmation
- Clear recovery for all error cases

---

## Design principles

- Big buttons and large typography
- Minimal steps (4 taps to complete most payments)
- Full-screen state feedback
- Calm, speakable error messages
- Designed for merchants and cashiers

---

## Tech stack

- Flutter
- Provider (ChangeNotifier)
- GoRouter
- In-memory state only

---

## Architecture overview

- **State management (`PosController`)**
  - Holds the current charge amount, selected `PaymentMethod` (card / QR), reader connection + battery state, and an in-memory list of `Transaction` objects.
  - Computes "today's total" and exposes helper views like the last 3 transactions and history filters (Today / Week / All).
  - Handles refunds in-place by marking a transaction as `refunded` (no persistence, all state resets on app restart).

- **Payment simulation (`PaymentSimulator`)**
  - Card payments: ~2s delay with a high chance of `approved`, otherwise `declined`.
  - QR payments: ~1s delay and always `approved` unless a forced error is triggered for demo purposes.
  - No network calls or external SDKs; everything runs locally in Dart.

- **Navigation (`GoRouter`)**
  - `/` → `HomeScreen` (today's total, last 3 transactions, entry to Charge)
  - `/amount` → `AmountEntryScreen` (large keypad and amount preview)
  - `/method` → `MethodSelectScreen` (Card vs QR)
  - `/card-wait`, `/qr`, `/processing`, `/result` → the payment flow screens (including success + rich error states)
  - `/history` → `HistoryScreen` with Today / Week filters
  - `/tx/:id` → `TransactionDetailScreen` with refund action and status badges

---

## Platform support and requirements

- **Primary target:** Android phones and emulators.
- **Minimum Android version:** API 21 (Android 5.0 Lollipop) or newer. Very old devices (e.g. Android 4.x / API 16) cannot install or run this Flutter build.
- **Tested environment:** Flutter 3.x on Windows 11, Android emulator (`sdk gphone64 x86 64`, API 36).
- **Web (optional demo):** For a quick clickable demo in the browser, you can run `flutter run -d chrome`, but the primary submission target is Android.

---

## Running the app

### Android (requested platform)

- Target: **Android 5.0 Lollipop (API 21) or newer**. Devices on Android 4.x / API 16 will not be able to install this app.
- Install **Flutter SDK** and **Android Studio** (with Android SDK and an emulator or a physical device with USB debugging enabled).
- Clone this repo and open a terminal in the `quicktap` folder.
- Run:

  ```bash
  flutter pub get
  flutter run -d android
  ```

  If you only have one Android device/emulator connected, you can also just run:

  ```bash
  flutter run
  ```

### Notes

- **Windows (if Flutter is not in PATH):** Edit `run.ps1` to set your Flutter `bin` path, then run `.\run.ps1` from the `quicktap` folder. See `RUN_QUICKTAP.md` for details.
- **First time:** If platform folders (android, ios, web) are missing, run once:

  ```bash
  flutter create . --project-name quicktap
  ```
