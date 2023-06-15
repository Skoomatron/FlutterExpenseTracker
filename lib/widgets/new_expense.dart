import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  Category _selectedCategory = Category.leisure;
  DateTime? _selectedDate;

  @override
  void dispose() {
    amountController.dispose();
    titleController.dispose();
    super.dispose();
  }

  void _submitExpense() {
    final dollars = double.tryParse(amountController.text);
    final amountValidator = dollars == null || dollars < 0;
    if (_selectedDate != null &&
        titleController.text.trim() != null &&
        !amountValidator) {
      setState(() {
        widget.onAddExpense(Expense(
            title: titleController.text.trim(),
            amount: dollars,
            date: _selectedDate!,
            category: _selectedCategory));
      });
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Close'))
                ],
                content: const Text('All Fields Are Required'),
                title: const Text('Invalid Input'),
              ));
      return;
    }
  }

  void _cancelModal() {
    Navigator.pop(context);
  }

  void _openDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(now.year - 3, now.month, now.day),
        lastDate: DateTime(now.year + 3, now.month, now.day));
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(context) {
    final keyboardSpace =
        MediaQuery.of(context).viewInsets.bottom; // pop keyboard space
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.name.toUpperCase()),
                            ),
                          )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null
                                ? 'No Date Selected'
                                : formatter.format(_selectedDate!)),
                            IconButton(
                                onPressed: _openDatePicker,
                                icon: const Icon(Icons.calendar_month))
                          ],
                        ),
                      ),
                    ],
                  )
                else
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\$ ',
                          label: Text('Amount'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_selectedDate == null
                              ? 'No Date Selected'
                              : formatter.format(_selectedDate!)),
                          IconButton(
                              onPressed: _openDatePicker,
                              icon: const Icon(Icons.calendar_month))
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                          onPressed: _submitExpense, child: const Text('Save')),
                      TextButton(
                          onPressed: _cancelModal, child: const Text('Cancel'))
                    ],
                  )
                else
                Row(
                  children: [
                    DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        }),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: _submitExpense, child: const Text('Save')),
                    TextButton(
                        onPressed: _cancelModal, child: const Text('Cancel'))
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
