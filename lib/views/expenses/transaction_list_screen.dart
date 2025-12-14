import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/transaction_provider.dart';
import '../../models/transaction.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
import 'add_transaction_screen.dart';

class TransactionListScreen extends StatefulWidget {
  static const String routeName = '/transactions';

  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final allTransactions = provider.transactions;
    final isDesktop = ResponsiveHelper.isDesktop(context);

    // simple filter logic
    final transactions = _selectedFilter == 'All'
        ? allTransactions
        : allTransactions.where((tx) {
            if (_selectedFilter == 'Income') return tx.type == TransactionType.income;
            if (_selectedFilter == 'Expense') return tx.type == TransactionType.expense;
            return true;
          }).toList();

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text('Expenses', style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: AppColors.background,
              scrolledUnderElevation: 0,
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AddTransactionScreen.routeName);
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add New', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDesktop) ...[
                  Text(
                    'Expenses & Transactions',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 20),
                ],
                
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'All',
                        isSelected: _selectedFilter == 'All',
                        onSelected: () => setState(() => _selectedFilter = 'All'),
                      ),
                      const SizedBox(width: 12),
                      _FilterChip(
                        label: 'Income',
                        isSelected: _selectedFilter == 'Income',
                        onSelected: () => setState(() => _selectedFilter = 'Income'),
                      ),
                      const SizedBox(width: 12),
                      _FilterChip(
                        label: 'Expense',
                        isSelected: _selectedFilter == 'Expense',
                        onSelected: () => setState(() => _selectedFilter = 'Expense'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: transactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long_rounded, size: 64, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text(
                                'No transactions found',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: transactions.length,
                          separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final tx = transactions[index];
                            return Dismissible(
                              key: ValueKey(tx.id),
                              background: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                // provider.deleteTransaction(tx.id); // Implement delete logic in provider
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Transaction deleted')),
                                );
                              },
                              child: Card(
                                elevation: 0,
                                color: Colors.white,
                                shadowColor: Colors.black.withOpacity(0.05),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(color: Colors.grey[100]!),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  leading: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: tx.type == TransactionType.expense
                                          ? AppColors.error.withOpacity(0.1)
                                          : AppColors.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      tx.type == TransactionType.expense
                                          ? Icons.arrow_downward_rounded
                                          : Icons.arrow_upward_rounded,
                                      color: tx.type == TransactionType.expense
                                          ? AppColors.error
                                          : AppColors.success,
                                    ),
                                  ),
                                  title: Text(
                                    tx.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat.yMMMd().format(tx.date),
                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        (tx.type == TransactionType.expense ? '-' : '+') +
                                            '\$${tx.amount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: tx.type == TransactionType.expense
                                              ? AppColors.error
                                              : AppColors.success,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
