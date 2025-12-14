import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fintrack_app/widgets/responsive_shell.dart';
import 'package:fintrack_app/screens/dashboard_screen.dart';
import 'package:fintrack_app/screens/transactions_screen.dart';
import 'package:fintrack_app/screens/goals_screen.dart';
import 'package:fintrack_app/screens/advisor_screen.dart';
import 'package:fintrack_app/screens/splash_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ResponsiveShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/transactions',
              builder: (context, state) => const TransactionsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/goals',
              builder: (context, state) => const GoalsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/advisor',
              builder: (context, state) => const AdvisorScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
