import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fintrack_app/core/utils/constants.dart';
import 'package:fintrack_app/widgets/mobile_navbar.dart';
import 'package:fintrack_app/widgets/sidebar.dart';

class ResponsiveShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ResponsiveShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768; // md breakpoint

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          // Main Layout
          Row(
            children: [
              if (isDesktop)
                DesktopSidebar(navigationShell: navigationShell),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacers.md),
                  child: navigationShell,
                ),
              ),
            ],
          ),
          
          // Mobile Navigation
          if (!isDesktop)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MobileNavbar(navigationShell: navigationShell),
            ),
        ],
      ),
    );
  }
}
