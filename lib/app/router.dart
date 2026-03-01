import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/pos/screens/home_screen.dart';
import '../features/pos/screens/amount_entry_screen.dart';
import '../features/pos/screens/method_select_screen.dart';
import '../features/pos/screens/card_wait_screen.dart';
import '../features/pos/screens/qr_display_screen.dart';
import '../features/pos/screens/processing_screen.dart';
import '../features/pos/screens/result_screen.dart';
import '../features/pos/screens/history_screen.dart';
import '../features/pos/screens/transaction_detail_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/amount',
        builder: (context, state) => const AmountEntryScreen(),
      ),
      GoRoute(
        path: '/method',
        builder: (context, state) => const MethodSelectScreen(),
      ),
      GoRoute(
        path: '/card-wait',
        builder: (context, state) => const CardWaitScreen(),
      ),
      GoRoute(
        path: '/qr',
        builder: (context, state) => const QrDisplayScreen(),
      ),
      GoRoute(
        path: '/processing',
        builder: (context, state) {
          final method = state.uri.queryParameters['method'] ?? 'card';
          final force = state.uri.queryParameters['force'] ?? '';
          return ProcessingScreen(
            method: method,
            forceDecline: force == 'declined',
            forceTimeout: force == 'timeout',
            forceReaderDisconnected: force == 'readerDisconnected',
          );
        },
      ),
      GoRoute(
        path: '/result',
        builder: (context, state) {
          final success =
              state.uri.queryParameters['success']?.toLowerCase() == 'true';
          final error = state.uri.queryParameters['error'] ?? '';
          return ResultScreen(success: success, errorType: error.isEmpty ? null : error);
        },
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/tx/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TransactionDetailScreen(transactionId: id);
        },
      ),
    ],
  );
}
