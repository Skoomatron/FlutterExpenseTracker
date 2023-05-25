import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {

  final List<Expense> _expenses = [
    Expense(title: 'Lunch', amount: 9.99, date: DateTime.now(), category: Category.food),
    Expense(title: 'Office Supply', amount: 109.99, date: DateTime.now(), category: Category.work),
    Expense(title: 'Bar Tab', amount: 68.45, date: DateTime.now(), category: Category.leisure)
  ];

  void _openExpenseModal() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense,),);
  }

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {

    final expenseIndex = _expenses.indexOf(expense);

    setState(() {
      _expenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _expenses.insert(expenseIndex, expense);
            });
          }),
      duration: const Duration(
        seconds: 3
      ),
        content: const Text('Expense Deleted!')));
  }

  @override
  Widget build(context) {
    Widget mainContent = const Center(
      child: Text(
       'No Expenses Found, Please Begin To Add Some!'
      ),
    );

    if (_expenses.isNotEmpty) {
      mainContent = ExpensesList(expenses: _expenses, removeExpense: _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(onPressed: _openExpenseModal, icon: const Icon(
            Icons.add_box_outlined
          ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}