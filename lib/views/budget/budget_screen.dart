import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';

class BudgetScreen extends StatelessWidget {
  static const String routeName = '/budget';

  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    // Mock Data
    final budgets = [
      {'category': 'Food & Dining', 'spent': 320.0, 'limit': 500.0, 'color': Colors.orange, 'icon': Icons.restaurant_rounded},
      {'category': 'Transportation', 'spent': 85.0, 'limit': 150.0, 'color': Colors.blue, 'icon': Icons.directions_car_rounded},
      {'category': 'Entertainment', 'spent': 120.0, 'limit': 200.0, 'color': Colors.purple, 'icon': Icons.movie_rounded},
      {'category': 'Utilities', 'spent': 180.0, 'limit': 200.0, 'color': Colors.teal, 'icon': Icons.bolt_rounded},
    ];

    final goals = [
      {'title': 'New Laptop', 'saved': 1200.0, 'target': 2000.0, 'icon': Icons.laptop_mac_rounded},
      {'title': 'Vacation', 'saved': 500.0, 'target': 1500.0, 'icon': Icons.beach_access_rounded},
      {'title': 'Emergency Fund', 'saved': 5000.0, 'target': 10000.0, 'icon': Icons.savings_rounded},
    ];

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
             title: const Text('Budgets & Goals', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    'Budgets & Goals',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 20),
                ],
                
                // Budgets Section
                _SectionHeader(
                  title: 'Monthly Budgets', 
                  action: TextButton(onPressed: (){}, child: const Text('Edit'))
                ),
                const SizedBox(height: 16),
                
                // Grid for Budgets on large screens, list on small
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: budgets.map((budget) => SizedBox(
                          width: (constraints.maxWidth - 16) / 2,
                          child: _BudgetCard(
                             category: budget['category'] as String,
                             spent: budget['spent'] as double,
                             limit: budget['limit'] as double,
                             color: budget['color'] as Color,
                             icon: budget['icon'] as IconData,
                           ),
                        )).toList(),
                      );
                    }
                     return Column(
                      children: budgets.map((budget) => _BudgetCard(
                        category: budget['category'] as String,
                        spent: budget['spent'] as double,
                        limit: budget['limit'] as double,
                        color: budget['color'] as Color,
                        icon: budget['icon'] as IconData,
                      )).toList(),
                    );
                  }
                ),

                const SizedBox(height: 32),
                _SectionHeader(title: 'Savings Goals', action: TextButton(onPressed: (){}, child: const Text('Add New'))),
                const SizedBox(height: 16),
                
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: goals.length,
                    separatorBuilder: (ctx, i) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      return Container(
                        width: 250,
                        child: _GoalCard(
                          title: goal['title'] as String,
                          saved: goal['saved'] as double,
                          target: goal['target'] as double,
                          icon: goal['icon'] as IconData,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;

  const _SectionHeader({required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final String category;
  final double spent;
  final double limit;
  final Color color;
  final IconData icon;

  const _BudgetCard({
    required this.category,
    required this.spent,
    required this.limit,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (spent / limit).clamp(0.0, 1.0);
    final isOverBudget = spent > limit;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey[100]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${spent.toStringAsFixed(0)} / \$${limit.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: isOverBudget ? AppColors.error : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(isOverBudget ? AppColors.error : color),
                minHeight: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String title;
  final double saved;
  final double target;
  final IconData icon;

  const _GoalCard({
    required this.title,
    required this.saved,
    required this.target,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
     final progress = (saved / target).clamp(0.0, 1.0);
     
    return Card(
      elevation: 4,
      shadowColor: AppColors.primary.withOpacity(0.2),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.secondary.withOpacity(0.1), AppColors.secondary.withOpacity(0.1)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: AppColors.secondary, size: 28),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'On Track',
                    style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
             Text(
              '\$${saved.toStringAsFixed(0)}',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            Text(
              'of \$${target.toStringAsFixed(0)} target',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 12),
             ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[100],
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
