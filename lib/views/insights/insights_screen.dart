import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';

class InsightsScreen extends StatelessWidget {
  static const String routeName = '/insights';

  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    // Mock chart data
    final sections = [
      PieChartSectionData(color: AppColors.secondary, value: 40, title: '40%', radius: 60, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      PieChartSectionData(color: Colors.orange, value: 30, title: '30%', radius: 55, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      PieChartSectionData(color: Colors.purple, value: 15, title: '15%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      PieChartSectionData(color: Colors.blue, value: 15, title: '15%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ];

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
             title: const Text('Insights & AI', style: TextStyle(fontWeight: FontWeight.bold)),
             backgroundColor: AppColors.background,
             scrolledUnderElevation: 0,
            ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 if (isDesktop) ...[
                  Text(
                    'Insights & AI Advice',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 20),
                ],
                
                // Chart Section Card
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'Spending Breakdown',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 300,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 60,
                              sections: sections,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: const [
                             _LegendItem(color: AppColors.secondary, text: 'Food & Dining'),
                             _LegendItem(color: Colors.orange, text: 'Rent & Utilities'),
                             _LegendItem(color: Colors.purple, text: 'Entertainment'),
                             _LegendItem(color: Colors.blue, text: 'Transportation'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'AI Financial Advice',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                           fontWeight: FontWeight.bold, 
                           color: AppColors.textPrimary
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                 _AiAdviceCard(
                  title: 'Reduce Eating Out',
                  description: 'Based on your recent transaction patterns, you spent 15% more on restaurants this month. Switching to home cooking for 2 days a week could save you ~\$150.',
                  icon: Icons.restaurant,
                  color: Colors.orange,
                ),
                _AiAdviceCard(
                  title: 'Boost Savings Goal',
                  description: 'You have a surplus of \$400 this month. Consider adding it to your "New Laptop" goal to reach it 2 weeks earlier!',
                  icon: Icons.rocket_launch_rounded,
                  color: AppColors.secondary,
                ),
                 _AiAdviceCard(
                  title: 'Subscription Alert',
                  description: 'You have 3 entertainment subscriptions totaling \$45/mo. Do you use all of them frequently?',
                  icon: Icons.notifications_active_rounded,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _AiAdviceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _AiAdviceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (){},
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.5,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
