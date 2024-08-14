import 'dart:math';

import 'package:explension/constants.dart';
import 'package:explension/injector.dart';
import 'package:explension/models/expense.dart';
import 'package:explension/services/expense.dart';
import 'package:explension/services/expense_category.dart';
import 'package:explension/services/expense_source.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Expense> _expenses;
  String _periodSelectedValue = 'This Week';
  String _walletSelectedValue = 'Cash';

  @override
  void initState() {
    super.initState();
    _expenses = sl<ExpenseService>().list();
  }

  /// TODO: Replace this function later with real function
  void _addRandomExpense() {
    final random = Random();

    final sources = sl<ExpenseSourceService>().list();
    final randomSource = sources[random.nextInt(sources.length)];

    final categories = sl<ExpenseCategoryService>().list();
    final randomCategory = categories[random.nextInt(categories.length)];

    final newExpense = Expense(
      amount: (random.nextInt(9) + 1).toDouble(),
      category: randomCategory,
      source: randomSource,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      note: 'Test Note',
    );

    sl<ExpenseService>().create(newExpense);

    setState(() {
      _expenses.add(newExpense);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the sum of the amounts of all expenses
    final totalAmount =
        _expenses.fold(0.0, (sum, expense) => sum + expense.amount);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              totalAmount.toString(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildDropdown(
                        value: _periodSelectedValue,
                        onChanged: (newValue) {
                          setState(() {
                            _periodSelectedValue = newValue!;
                          });
                        },
                        items: ['This Week', 'This Month', 'This Year'],
                      ),
                      const SizedBox(width: 20),
                      _buildDropdown(
                        value: _walletSelectedValue,
                        onChanged: (newValue) {
                          setState(() {
                            _walletSelectedValue = newValue!;
                          });
                        },
                        items: ['Cash', 'Credit Card'],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final expenses = _expenses.reversed.toList();

                // Get the reversed list of expenses
                return _buildTransactionTile(expenses[index], index);
              },
              childCount: _expenses.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addRandomExpense();
        },
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required void Function(String?) onChanged,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionTile(Expense expense, int index) {
    final backgroundColor = index % 2 == 0 ? Colors.grey[200] : Colors.white;

    return Container(
      color: backgroundColor,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          width: 50,
          decoration: BoxDecoration(
            color: expense.category.color != null
                ? Color(expense.category.color!)
                : null,
            shape: BoxShape.circle,
          ),
          child: Icon(
            expense.category.icon,
            color: Colors.white,
          ),
        ),
        title: Text(expense.category.name.toString()),
        subtitle: expense.note != null ? Text(expense.note!) : null,
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rp ${(expense.amount).toStringAsFixed(2)}',
            ),
            Text(
              expense.source.name,
            ),
          ],
        ),
      ),
    );
  }
}
