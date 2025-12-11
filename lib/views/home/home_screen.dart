import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    // Dummy Recent Transactions
    final recentTransactions = [
      {'title': 'Grocery Shopping', 'amount': -120.50, 'date': 'Today', 'icon': Icons.shopping_bag_outlined},
      {'title': 'Freelance Payment', 'amount': 420.00, 'date': 'Yesterday', 'icon': Icons.work_outline},
      {'title': 'Netflix Subscription', 'amount': -14.99, 'date': '2 days ago', 'icon': Icons.movie_outlined},
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text('FinTrack', style: TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.bgGradient,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: isDesktop ? 40 : 100, // Adjust for transparent/missing app bar
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Overview of your finances',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _GlassSummaryCard(
                          title: 'Total Balance',
                          amount: '\$12,450.00',
                          gradient: AppColors.primaryGradient,
                          icon: Icons.account_balance_wallet_rounded,
                        ),
                      ),
                       if (!isDesktop) ...[
                          const SizedBox(width: 16),
                          Expanded(
                            child: _GlassSummaryCard(
                              title: 'Income',
                              amount: '\$4,200.00',
                              color: AppColors.success,
                              icon: Icons.trending_up_rounded,
                              isGradient: false,
                            ),
                          ),
                       ],
                    ],
                  ),
                  
                   if (isDesktop) ...[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                           Expanded(
                            child: _GlassSummaryCard(
                              title: 'Income',
                              amount: '\$4,200.00',
                              color: AppColors.success,
                              icon: Icons.trending_up_rounded,
                              isGradient: false,
                            ),
                          ),
                           const SizedBox(width: 20),
                           Expanded(
                            child: _GlassSummaryCard(
                              title: 'Expenses',
                              amount: '\$1,850.00',
                              color: AppColors.error,
                              icon: Icons.trending_down_rounded,
                              isGradient: false,
                            ),
                          ),
                        ]
                      )
                   ] else ...[
                      const SizedBox(height: 16),
                      // Mobile layout for the third card
                       Row(
                        children: [
                           Expanded(
                            child: _GlassSummaryCard(
                              title: 'Expenses',
                              amount: '\$1,850.00',
                              color: AppColors.error,
                              icon: Icons.trending_down_rounded,
                              isGradient: false,
                            ),
                          ),
                        ]
                       )
                   ],

                  const SizedBox(height: 32),
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Animated List of Transactions
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentTransactions.length,
                    itemBuilder: (context, index) {
                      final tx = recentTransactions[index];
                      final isExpense = (tx['amount'] as double) < 0;
                      
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.grey[100]!),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isExpense ? AppColors.error.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                tx['icon'] as IconData,
                                color: isExpense ? AppColors.error : AppColors.success,
                              ),
                            ),
                            title: Text(
                              tx['title'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              tx['date'] as String,
                              style: const TextStyle(color: AppColors.textSecondary),
                            ),
                            trailing: Text(
                              (isExpense ? '' : '+') + '\$${(tx['amount'] as double).abs().toStringAsFixed(2)}',
                              style: TextStyle(
                                color: isExpense ? AppColors.error : AppColors.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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

class _GlassSummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color? color;
  final Gradient? gradient;
  final bool isGradient;

  const _GlassSummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    this.color,
    this.gradient,
    this.isGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170, // Increased height to prevent overflow
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isGradient ? null : Colors.white,
        gradient: isGradient ? gradient : null,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isGradient ? AppColors.primary : Colors.black).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: !isGradient ? Border.all(color: Colors.grey[100]!) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isGradient ? Colors.white.withOpacity(0.2) : color!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isGradient ? Colors.white : color,
                  size: 24,
                ),
              ),
              if (isGradient)
                Icon(Icons.more_horiz, color: Colors.white.withOpacity(0.6)),
            ],
          ),
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                title,
                style: TextStyle(
                  color: isGradient ? Colors.white.withOpacity(0.8) : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: TextStyle(
                  color: isGradient ? Colors.white : AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
           )
        ],
      ),
    );
  }
}
