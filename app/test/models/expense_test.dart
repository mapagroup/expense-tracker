import 'package:flutter_test/flutter_test.dart';
import 'package:mapa_money/models/expense.dart';

void main() {
  group('Expense model', () {
    final testDate = DateTime(2025, 3, 15);

    test('creates instance with required fields', () {
      final expense = Expense(
        title: 'Lunch',
        amount: 250.0,
        date: testDate,
        category: 'Food',
      );

      expect(expense.title, equals('Lunch'));
      expect(expense.amount, equals(250.0));
      expect(expense.date, equals(testDate));
      expect(expense.category, equals('Food'));
      expect(expense.id, isNull);
      expect(expense.description, isNull);
    });

    test('creates instance with all fields', () {
      final expense = Expense(
        id: 1,
        title: 'Electricity bill',
        amount: 1500.0,
        date: testDate,
        category: 'Bills',
        description: 'Monthly bill',
      );

      expect(expense.id, equals(1));
      expect(expense.description, equals('Monthly bill'));
    });

    group('toMap', () {
      test('serialises all fields correctly', () {
        final expense = Expense(
          id: 5,
          title: 'Bus fare',
          amount: 30.0,
          date: testDate,
          category: 'Transport',
          description: 'Office commute',
        );

        final map = expense.toMap();

        expect(map['id'], equals(5));
        expect(map['title'], equals('Bus fare'));
        expect(map['amount'], equals(30.0));
        expect(map['date'], equals(testDate.toIso8601String()));
        expect(map['category'], equals('Transport'));
        expect(map['description'], equals('Office commute'));
      });

      test('serialises null id correctly', () {
        final expense = Expense(
          title: 'Coffee',
          amount: 60.0,
          date: testDate,
          category: 'Food',
        );

        expect(expense.toMap()['id'], isNull);
      });
    });

    group('fromMap', () {
      test('deserialises all fields correctly', () {
        final map = {
          'id': 3,
          'title': 'Movie ticket',
          'amount': 400.0,
          'date': testDate.toIso8601String(),
          'category': 'Entertainment',
          'description': 'Weekend outing',
        };

        final expense = Expense.fromMap(map);

        expect(expense.id, equals(3));
        expect(expense.title, equals('Movie ticket'));
        expect(expense.amount, equals(400.0));
        expect(expense.date, equals(testDate));
        expect(expense.category, equals('Entertainment'));
        expect(expense.description, equals('Weekend outing'));
      });

      test('deserialises null description correctly', () {
        final map = {
          'id': 7,
          'title': 'Petrol',
          'amount': 2000.0,
          'date': testDate.toIso8601String(),
          'category': 'Transport',
          'description': null,
        };

        final expense = Expense.fromMap(map);
        expect(expense.description, isNull);
      });
    });

    test('toMap and fromMap are inverse operations', () {
      final original = Expense(
        id: 10,
        title: 'Groceries',
        amount: 875.25,
        date: testDate,
        category: 'Food',
        description: 'Weekly shopping',
      );

      final roundTripped = Expense.fromMap(original.toMap());

      expect(roundTripped.id, equals(original.id));
      expect(roundTripped.title, equals(original.title));
      expect(roundTripped.amount, equals(original.amount));
      expect(roundTripped.date, equals(original.date));
      expect(roundTripped.category, equals(original.category));
      expect(roundTripped.description, equals(original.description));
    });

    test('toString contains key fields', () {
      final expense = Expense(
        id: 1,
        title: 'Test',
        amount: 99.0,
        date: testDate,
        category: 'Other',
      );

      final str = expense.toString();
      expect(str, contains('id: 1'));
      expect(str, contains('title: Test'));
      expect(str, contains('amount: 99.0'));
    });
  });
}
