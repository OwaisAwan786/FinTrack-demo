import 'package:flutter/material.dart';
import 'package:fintrack_app/core/models/models.dart';
import 'dart:async';

class FinTrackProvider extends ChangeNotifier {
  // Initial Mock Data
  List<Transaction> _transactions = [
    Transaction(id: 1, title: 'Grocery Shopping', amount: 1200, category: 'Food', date: '2023-10-24', type: 'expense'),
    Transaction(id: 2, title: 'Uber Ride', amount: 350, category: 'Transport', date: '2023-10-25', type: 'expense'),
    Transaction(id: 3, title: 'Freelance Payment', amount: 15000, category: 'Income', date: '2023-10-26', type: 'income'),
  ];

  double _savingsPocket = 2450;
  double _budget = 20000;
  List<Goal> _goals = [
    Goal(id: 1, name: 'New Laptop', target: 80000, current: 15000, color: '#6366F1'),
    Goal(id: 2, name: 'Emergency Fund', target: 50000, current: 20000, color: '#10B981'),
  ];
  List<AppNotification> _notifications = [];

  // Getters
  List<Transaction> get transactions => _transactions;
  double get savingsPocket => _savingsPocket;
  double get budget => _budget;
  List<Goal> get goals => _goals;
  List<AppNotification> get notifications => _notifications;

  double get totalBalance {
    double income = _transactions
        .where((t) => t.type == 'income')
        .fold(0, (sum, t) => sum + t.amount);
    double expenses = _transactions
        .where((t) => t.type == 'expense')
        .fold(0, (sum, t) => sum + t.amount);
    return income - expenses;
  }

  double get monthlySpending {
    return _transactions
        .where((t) => t.type == 'expense')
        .fold(0, (sum, t) => sum + t.amount);
  }

  void addNotification(String message, {String type = 'info'}) {
    final id = DateTime.now().millisecondsSinceEpoch;
    final notification = AppNotification(id: id, message: message, type: type);
    _notifications.add(notification);
    notifyListeners();

    // Auto-dismiss after 5 seconds
    Timer(const Duration(seconds: 5), () {
      _notifications.removeWhere((n) => n.id == id);
      notifyListeners();
    });
  }

  void addTransaction(Transaction transaction) {
    final newTransaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch, 
      title: transaction.title, 
      amount: transaction.amount, 
      category: transaction.category, 
      date: transaction.date, 
      type: transaction.type
    );
    
    _transactions.insert(0, newTransaction);

    if (newTransaction.type == 'expense') {
      final amount = newTransaction.amount;
      // Smart Auto-Save: Round up to nearest 500
      final roundedUp = (amount / 500).ceil() * 500;
      final savings = roundedUp - amount;

      if (savings > 0) {
        _savingsPocket += savings;
        addNotification('Auto-saved PKR ${savings.toInt()} to Savings Pocket! (Rounded to $roundedUp)', type: 'success');
      }
    } else if (newTransaction.type == 'income') {
      addNotification('Income received: PKR ${newTransaction.amount}', type: 'success');
    }
    notifyListeners();
  }

  void addGoal(String name, double target, String color) {
    final newGoal = Goal(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      target: target,
      current: 0,
      color: color,
    );
    _goals.add(newGoal);
    addNotification('New Goal "$name" created!', type: 'success');
    notifyListeners();
  }

  void simulateBillPayment() {
    const billAmount = 4500.0;
    addTransaction(Transaction(
      id: 0, // Will be overwritten
      title: 'Electricity Bill',
      amount: billAmount,
      category: 'Bills',
      date: DateTime.now().toIso8601String().split('T')[0],
      type: 'expense',
    ));
    addNotification('Automatic Payment: Electricity Bill (PKR $billAmount) paid.', type: 'warning');
  }
}
