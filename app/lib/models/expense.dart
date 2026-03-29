class Expense {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String? description;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.description,
  });

  // Convert Expense to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'description': description,
    };
  }

  // Create Expense from Map retrieved from database
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'] as String),
      category: map['category'] as String,
      description: map['description'] as String?,
    );
  }

  @override
  String toString() =>
      'Expense(id: $id, title: $title, amount: $amount, date: $date, category: $category)';
}
