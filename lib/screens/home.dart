import 'dart:math';

import 'package:explension/constants.dart';
import 'package:explension/models/expense.dart';
import 'package:explension/services/expense.dart';
import 'package:explension/services/source.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Expense> _expenses = [];
  final ExpenseService _expenseService = ExpenseService();
  final SourceService _sourceService = SourceService();
  String _periodSelectedValue = 'This Week';
  String _walletSelectedValue = 'Cash';

  // TODO: Replace this function later with real function
  void _addRandomExpense() {
    final random = Random();

    final amount = random.nextInt(9) + 1;

    final categoryId = random.nextInt(10) + 1;

    // create a list of default sources
    final sources = _sourceService.getSources();

    // select a random source from the list of default sources
    final source = sources[random.nextInt(sources.length)];

    final newExpense = Expense(
      amount: amount.toDouble(),
      categoryId: categoryId,
      source: source,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      note: 'Test Note',
    );

    _expenseService.addExpense(newExpense);

    setState(() {
      _expenses.add(newExpense);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              "IDR 30.000.000",
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
                // Get the reversed list of expenses
                final expenses =
                    _expenseService.getExpenses().reversed.toList();
                return _buildTransactionTile(expenses[index]);
              },
              childCount: _expenseService.getExpenses().length,
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

  Widget _buildTransactionTile(Expense expense) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        width: 100,
        child: const Placeholder(child: Text("Expense Category")),
      ),
      title: Text(expense.categoryId.toString()),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(expense.source.name),
          Text(expense.note ?? ""),
        ],
      ),
      trailing: Text(
        '\$${(expense.amount).toStringAsFixed(2)}',
      ),
    );
  }
}
