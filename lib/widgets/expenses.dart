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
    setState(() {
      _expenses.remove(expense);
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: _openExpenseModal, icon: const Icon(
            Icons.add_box_outlined
          ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ExpensesList(expenses: _expenses, removeExpense: _removeExpense),
          ),
        ],
      ),
    );
  }
}