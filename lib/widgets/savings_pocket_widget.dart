import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fintrack_app/core/utils/constants.dart';
import 'package:fintrack_app/core/utils/formatters.dart';

class SavingsPocketWidget extends StatelessWidget {
  final dynamic balance; // String or double

  const SavingsPocketWidget({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF7E22CE)], // indigo-600 to purple-700
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.wallet, color: Color(0xFFE0E7FF), size: 24),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(LucideIcons.sparkles, color: Color(0xFF86EFAC), size: 12),
                      SizedBox(width: 4),
                      Text(
                        'Auto-Save Active',
                        style: TextStyle(
                          color: Color(0xFFBBF7D0),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacers.vLg,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Savings Pocket',
                  style: TextStyle(
                    color: Color(0xFFC7D2FE),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  balance is num
                      ? Formatters.formatCurrency(balance as double)
                      : balance.toString(),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Smartly saved from your daily spends.',
                  style: TextStyle(
                    color: Color(0xFFA5B4FC),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
}
