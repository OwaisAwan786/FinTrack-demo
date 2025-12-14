import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:fintrack_app/core/models/models.dart';
import 'package:fintrack_app/core/utils/constants.dart';
import 'package:fintrack_app/core/utils/formatters.dart';
import 'package:fintrack_app/providers/fintrack_provider.dart';
import 'package:fintrack_app/widgets/glass_panel.dart';
import 'package:fintrack_app/widgets/savings_pocket_widget.dart';
import 'package:fintrack_app/widgets/stats_widget.dart';
import 'package:fintrack_app/widgets/transaction_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _showBalance = false;
  bool _isSimulating = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<FinTrackProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (MediaQuery.of(context).size.width < 768) ...[
                     const Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                          Text('Welcome Back!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                       ],
                     ),
                  ] else ...[
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('Here\'s your financial overview for today.', style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 40,
                            child: OutlinedButton.icon(
                              onPressed: () => setState(() => _showBalance = !_showBalance),
                              icon: Icon(_showBalance ? LucideIcons.eyeOff : LucideIcons.eye, size: 18, color: AppColors.textPrimary),
                              label: Text(_showBalance ? "Hide Balance" : "Show Balance", style: const TextStyle(color: AppColors.textPrimary)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.borderColor),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                backgroundColor: AppColors.surfaceHover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed: _isSimulating ? null : () {
                                setState(() => _isSimulating = true);
                                Future.delayed(const Duration(milliseconds: 600), () {
                                   final t = Transaction(
                                     id: DateTime.now().millisecondsSinceEpoch,
                                     title: 'Fancy Dinner',
                                     amount: 900.0,
                                     category: 'Food',
                                     date: DateTime.now().toIso8601String().split('T')[0],
                                     type: 'expense',
                                   );
                                   if (context.mounted) {
                                      provider.addTransaction(t);
                                      setState(() => _isSimulating = false);
                                   }
                                });
                              },
                              icon: const Icon(LucideIcons.plus, size: 18),
                              label: Text(_isSimulating ? 'Processing...' : 'Simulate Spend (Rs. 900)'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ],
                ],
              ),
              AppSpacers.vLg,

              // Stats Grid
              LayoutBuilder(builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 900;
                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    SizedBox(
                      width: isDesktop ? (constraints.maxWidth - 48) / 3 : constraints.maxWidth,
                      child: StatsWidget(
                        title: 'Total Balance',
                        amount: _showBalance ? Formatters.formatCurrency(provider.totalBalance) : 'PKR ****',
                        icon: LucideIcons.dollarSign,
                        trend: '+2.5%',
                        trendUp: true,
                      ),
                    ),
                    SizedBox(
                      width: isDesktop ? (constraints.maxWidth - 48) / 3 : constraints.maxWidth,
                      child: StatsWidget(
                        title: 'Monthly Spending',
                        amount: _showBalance ? Formatters.formatCurrency(provider.monthlySpending) : 'PKR ****',
                        icon: LucideIcons.trendingDown,
                        trend: 'Within Budget',
                        trendUp: true,
                      ),
                    ),
                    SizedBox(
                      width: isDesktop ? (constraints.maxWidth - 48) / 3 : constraints.maxWidth,
                      child: SavingsPocketWidget(balance: _showBalance ? provider.savingsPocket : 'PKR ****'),
                    ),
                  ],
                );
              }),
              AppSpacers.vLg,

              // Main Content
              LayoutBuilder(builder: (context, constraints) {
                 final isLarge = constraints.maxWidth > 1024;
                 return isLarge 
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                // Chart Placeholder
                                Container(
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(LucideIcons.trendingUp, size: 48, color: Colors.grey),
                                        SizedBox(height: 16),
                                        Text('Spending Analytics coming soon...', style: TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                AppSpacers.vLg,
                                TransactionList(transactions: provider.transactions),
                              ],
                            ),
                          ),
                          AppSpacers.hLg,
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                // Budget Progress
                                GlassPanel(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Monthly Budget', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      AppSpacers.vMd,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Spent', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                          Text(
                                            '${Formatters.formatCurrency(provider.monthlySpending)} / ${Formatters.formatCurrency(provider.budget)}',
                                            style: const TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      LinearProgressIndicator(
                                        value: (provider.monthlySpending / provider.budget).clamp(0.0, 1.0),
                                        backgroundColor: AppColors.surfaceHover,
                                        color: AppColors.primaryColor,
                                        minHeight: 8,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'You have spent ${(provider.monthlySpending / provider.budget * 100).round()}% of your budget.',
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                AppSpacers.vLg,
                                // Smart Tip
                                GlassPanel(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Smart Tip', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.successColor)),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Great job! You saved Rs. 100 extra this week by skipping coffee. That\'s enough for a small treat!',
                                        style: TextStyle(color: Color(0xFFD1D5DB), fontSize: 13, height: 1.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                             // Chart Placeholder
                                Container(
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(LucideIcons.trendingUp, size: 48, color: Colors.grey),
                                        SizedBox(height: 16),
                                        Text('Spending Analytics coming soon...', style: TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                AppSpacers.vLg,
                                TransactionList(transactions: provider.transactions),
                                AppSpacers.vLg,
                                // Budget & Tips
                                GlassPanel(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Monthly Budget', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      AppSpacers.vMd,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Spent', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                          Text(
                                            '${Formatters.formatCurrency(provider.monthlySpending)} / ${Formatters.formatCurrency(provider.budget)}',
                                            style: const TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      LinearProgressIndicator(
                                        value: (provider.monthlySpending / provider.budget).clamp(0.0, 1.0),
                                        backgroundColor: AppColors.surfaceHover,
                                        color: AppColors.primaryColor,
                                        minHeight: 8,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'You have spent ${(provider.monthlySpending / provider.budget * 100).round()}% of your budget.',
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                    );
              }),
            ],
          ),
        );
      },
    );
  }
}
