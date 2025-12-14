import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fintrack_app/core/utils/constants.dart';
import 'package:fintrack_app/widgets/glass_panel.dart';

class DesktopSidebar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DesktopSidebar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacers.md),
        child: GlassPanel(
          padding: const EdgeInsets.all(AppSpacers.lg),
          child: Column(
            children: [
              // Logo
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'F',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  AppSpacers.hSm,
                  const Text(
                    'FinTrack',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              AppSpacers.vLg,
              
              // Nav Items
              _buildNavItem(0, LucideIcons.layoutDashboard, 'Dashboard'),
              _buildNavItem(1, LucideIcons.receipt, 'Transactions'),
              _buildNavItem(2, LucideIcons.target, 'Goals'),
              _buildNavItem(3, LucideIcons.brainCircuit, 'AI Advisor'),
              
              const Spacer(),
              
              const Divider(color: AppColors.borderColor),
              AppSpacers.vMd,
              
              _buildSideButton(LucideIcons.settings, 'Settings'),
              AppSpacers.vSm,
              _buildSideButton(LucideIcons.logOut, 'Logout', isDanger: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = navigationShell.currentIndex == index;
    return GestureDetector(
      onTap: () => navigationShell.goBranch(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.1),
                    AppColors.primaryColor.withOpacity(0.0)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          border: Border(
            left: BorderSide(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            AppSpacers.hSm,
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideButton(IconData icon, String label, {bool isDanger = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDanger ? AppColors.dangerColor.withOpacity(0.1) : Colors.transparent,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDanger ? AppColors.dangerColor : AppColors.textSecondary,
          ),
          AppSpacers.hSm,
          Text(
            label,
            style: TextStyle(
              color: isDanger ? AppColors.dangerColor : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
