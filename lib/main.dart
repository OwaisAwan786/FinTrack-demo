import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack_app/core/theme/app_theme.dart';
import 'package:fintrack_app/providers/fintrack_provider.dart';
import 'package:fintrack_app/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FinTrackApp());
}

class FinTrackApp extends StatelessWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FinTrackProvider()),
      ],
      child: MaterialApp.router(
        title: 'FinTrack',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
