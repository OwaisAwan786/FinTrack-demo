import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fintrack_app/core/utils/constants.dart';
import 'package:fintrack_app/widgets/glass_panel.dart';

class MobileNavbar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MobileNavbar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacers.md),
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        borderRadius: BorderRadius.circular(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, 0, LucideIcons.layoutDashboard, 'Home'),
            _buildNavItem(context, 1, LucideIcons.receipt, 'Transact'),
            _buildNavItem(context, 2, LucideIcons.target, 'Goals'),
            _buildNavItem(context, 3, LucideIcons.brainCircuit, 'Advisor'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = navigationShell.currentIndex == index;
    return GestureDetector(
      onTap: () => navigationShell.goBranch(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppColors.primaryColor : AppColors.textSecondary,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
