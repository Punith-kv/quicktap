import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'features/pos/pos_controller.dart';

void main() {
  runApp(const QuickTapApp());
}

class QuickTapApp extends StatelessWidget {
  const QuickTapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PosController(),
      child: MaterialApp.router(
        title: 'QuickTap',
        theme: appTheme,
        routerConfig: createRouter(),
      ),
    );
  }
}
