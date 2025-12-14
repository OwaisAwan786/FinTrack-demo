import 'dart:math';
import 'package:fintrack_app/core/models/models.dart';
import 'package:fintrack_app/core/utils/formatters.dart';

class Insight {
  final String id;
  final String type; // 'warning', 'danger', 'success', 'info', 'tip'
  final String title;
  final String message;
  final String action;

  Insight({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.action,
  });
}

class AiLogic {
  static Map<String, dynamic> generateInsights(
    List<Transaction> transactions,
    double budget,
    double savingsPocket,
  ) {
    List<Insight> insights = [];

    // 1. Calculate Metrics
    final expenses = transactions.where((t) => t.type == 'expense');
    double totalSpent = 0;
    if (expenses.isNotEmpty) {
      totalSpent = expenses.fold(0, (sum, t) => sum + t.amount);
    }
    
    Map<String, double> categoryTotals = {};
    for (var t in expenses) {
      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
    }

    // 2. Health Score
    double healthScore = 100;
    if (totalSpent > budget) {
      healthScore = max(0, 100 - ((totalSpent - budget) / budget * 100));
    } else {
      if (budget > 0) {
        double ratio = totalSpent / budget;
        if (ratio > 0.8) healthScore -= 10;
        if (ratio > 0.9) healthScore -= 10;
      }
    }
    healthScore = healthScore.roundToDouble();

    // 3. Rule-Based Insights
    categoryTotals.forEach((category, amount) {
      if (totalSpent > 0 && amount > totalSpent * 0.3) {
        insights.add(Insight(
          id: 'high-spend-$category',
          type: 'warning',
          title: 'High Spending in $category',
          message:
              'You\'ve spent ${Formatters.formatCurrency(amount)} on $category, which is ${(amount / totalSpent * 100).round()}% of your total expenses. Consider cutting back here.',
          action: 'Set a limit',
        ));
      }
    });

    if (totalSpent > budget * 0.9) {
      insights.add(Insight(
        id: 'budget-critical',
        type: 'danger',
        title: 'Critical Budget Alert',
        message:
            'You have used ${(totalSpent / budget * 100).round()}% of your monthly budget. Stop non-essential spending immediately!',
        action: 'Review Expenses',
      ));
    } else if (totalSpent > budget * 0.75) {
      insights.add(Insight(
        id: 'budget-warning',
        type: 'warning',
        title: 'Budget Watch',
        message:
            'You have used ${(totalSpent / budget * 100).round()}% of your budget. Keep an eye on discretionary spending.',
        action: 'Check Budget',
      ));
    }

    if (savingsPocket > 50000) {
      insights.add(Insight(
        id: 'invest-opp',
        type: 'success',
        title: 'Investment Opportunity',
        message:
            'Great job! Your Savings Pocket has ${Formatters.formatCurrency(savingsPocket)}. You should move at least PKR 50,000 into a Mutual Fund.',
        action: 'View Options',
      ));
    } else if (savingsPocket > 10000) {
      insights.add(Insight(
        id: 'saving-good',
        type: 'info',
        title: 'Emergency Fund Building',
        message:
            'You have ${Formatters.formatCurrency(savingsPocket)} saved. Keep going until you reach PKR 50,000.',
        action: 'Set Goal',
      ));
    }

    final tips = [
      "Try the 50/30/20 rule: 50% needs, 30% wants, 20% savings.",
      "Automating your savings effectively 'pays you first'.",
      "Review your subscriptions. Cancel any you haven't used in 3 months.",
      "Cooking at home can save you up to PKR 15,000 per month compared to daily takeout."
    ];
    insights.add(Insight(
      id: 'daily-tip',
      type: 'tip',
      title: 'Smart Money Tip',
      message: tips[Random().nextInt(tips.length)],
      action: 'Learn More',
    ));

    return {'insights': insights, 'healthScore': healthScore.toInt()};
  }
}
