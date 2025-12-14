import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      title: 'Grocery Shopping',
      amount: 120.50,
      date: DateTime.now(),
      type: TransactionType.expense,
      category: 'Food',
    ),
    Transaction(
      id: '2',
      title: 'Salary',
      amount: 4200.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: TransactionType.income,
      category: 'Salary',
    ),
    Transaction(
      id: '3',
      title: 'Netflix Subscription',
      amount: 14.99,
      date: DateTime.now().subtract(const Duration(days: 5)),
      type: TransactionType.expense,
      category: 'Entertainment',
    ),
  ];

  List<Transaction> get transactions => [..._transactions];

  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }
}
