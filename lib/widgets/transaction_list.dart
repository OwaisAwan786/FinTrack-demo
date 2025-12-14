import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fintrack_app/core/models/models.dart';
import 'package:fintrack_app/core/utils/constants.dart';
import 'package:fintrack_app/core/utils/formatters.dart';
import 'package:fintrack_app/widgets/glass_panel.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(AppSpacers.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          AppSpacers.vMd,
          if (transactions.isEmpty)
             const Padding(
               padding: EdgeInsets.symmetric(vertical: 24),
               child: Center(child: Text('No transactions yet.', style: TextStyle(color: AppColors.textSecondary))),
             )
          else
            ...transactions.map((t) => _TransactionItem(transaction: t)),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const _TransactionItem({required this.transaction});

  IconData _getIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return LucideIcons.coffee;
      case 'shopping':
        return LucideIcons.shoppingBag;
      case 'income':
        return LucideIcons.arrowUpRight;
      default:
        return LucideIcons.zap;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getIcon(transaction.category);
    final isIncome = transaction.type.toLowerCase() == 'income';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isIncome ? AppColors.successColor.withOpacity(0.2) : AppColors.primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isIncome ? AppColors.successColor : AppColors.primaryColor,
                ),
              ),
              AppSpacers.hMd,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${transaction.date} • ${transaction.category}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '${isIncome ? '+' : '-'}${Formatters.formatCurrency(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isIncome ? AppColors.successColor : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
