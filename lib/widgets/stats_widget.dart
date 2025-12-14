import 'package:flutter/material.dart';
import 'package:fintrack_app/core/utils/constants.dart';
import 'package:fintrack_app/widgets/glass_panel.dart';

class StatsWidget extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final String? trend;
  final bool trendUp;

  const StatsWidget({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    this.trend,
    this.trendUp = true,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(AppSpacers.lg),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Opacity(
              opacity: 0.1,
              child: Icon(icon, size: 64, color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppSpacers.vXs,
              Text(
                amount,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              if (trend != null) ...[
                AppSpacers.vSm,
                Row(
                  children: [
                    Text(
                      trend!,
                      style: TextStyle(
                        color: trendUp ? AppColors.successColor : AppColors.dangerColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
