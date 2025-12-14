import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack_app/core/utils/constants.dart';
import 'package:fintrack_app/providers/fintrack_provider.dart';
import 'package:fintrack_app/widgets/add_transaction_form.dart';
import 'package:fintrack_app/widgets/transaction_list.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transactions',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text('Manage your expenses and income.', style: TextStyle(color: AppColors.textSecondary)),
          AppSpacers.vLg,

          LayoutBuilder(builder: (context, constraints) {
            final isLarge = constraints.maxWidth > 1024;
             if (isLarge) {
               return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Consumer<FinTrackProvider>(
                        builder: (context, provider, child) => TransactionList(transactions: provider.transactions),
                      ),
                    ),
                    AppSpacers.hLg,
                    const Expanded(
                      flex: 1,
                      child: AddTransactionForm(),
                    ),
                  ],
               );
             } else {
               return Column(
                 children: [
                   const AddTransactionForm(),
                   AppSpacers.vLg,
                   Consumer<FinTrackProvider>(
                        builder: (context, provider, child) => TransactionList(transactions: provider.transactions),
                  ),
                 ],
               );
             }
          }),
        ],
      ),
    );
  }
}
