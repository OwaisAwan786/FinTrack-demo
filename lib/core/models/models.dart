class Transaction {
  final int id;
  final String title;
  final double amount;
  final String category;
  final String date;
  final String type; // 'income' or 'expense'

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
  });
}

class Goal {
  final int id;
  final String name;
  final double target;
  final double current;
  final String color;

  Goal({
    required this.id,
    required this.name,
    required this.target,
    required this.current,
    required this.color,
  });

  Goal copyWith({double? current}) {
    return Goal(
      id: id,
      name: name,
      target: target,
      current: current ?? this.current,
      color: color,
    );
  }
}

class AppNotification {
  final int id;
  final String message;
  final String type; // 'info', 'success', 'warning'

  AppNotification({
    required this.id,
    required this.message,
    this.type = 'info',
  });
}
