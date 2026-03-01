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

## Running the app

```bash
cd quicktap
flutter pub get
flutter run
```

**Windows (if Flutter is not in PATH):** Edit `run.ps1` to set your Flutter `bin` path, then run `.\run.ps1` from the `quicktap` folder. See `RUN_QUICKTAP.md` for details.

**First time:** If platform folders (android, ios, web) are missing, run once:

```bash
flutter create . --project-name quicktap
```
