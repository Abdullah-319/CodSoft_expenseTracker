import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/new_expense.dart';

import '../../widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<Expense> _rigesteredExpenses = [];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _rigesteredExpenses.add(expense);
    });
    Navigator.of(context).pop();
  }

  void _removeExpense(Expense expense) {
    int expenseIndex = _rigesteredExpenses.indexOf(expense);

    setState(() {
      _rigesteredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense removed'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _rigesteredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: width < 600
            ? Column(
                children: [
                  Chart(expenses: _rigesteredExpenses),
                  Expanded(
                    child: _rigesteredExpenses.isEmpty
                        ? const Center(
                            child: Text(
                              'No Expenses, try adding some!',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ExpensesList(
                            expenses: _rigesteredExpenses,
                            onRemoveExpense: _removeExpense,
                          ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenses: _rigesteredExpenses)),
                  Expanded(
                    child: _rigesteredExpenses.isEmpty
                        ? const Center(
                            child: Text(
                              'No Expenses, try adding some!',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ExpensesList(
                            expenses: _rigesteredExpenses,
                            onRemoveExpense: _removeExpense,
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
