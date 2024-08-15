import 'dart:math';

import 'package:explension/constants.dart';
import 'package:explension/injector.dart';
import 'package:explension/models/expense.dart';
import 'package:explension/models/expense_source.dart';
import 'package:explension/services/expense.dart';
import 'package:explension/services/expense_category.dart';
import 'package:explension/services/expense_source.dart';
import 'package:explension/services/expense_sub_category.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Expense> _expenses;
  late List<Expense> _filteredExpenses;
  late List<ExpenseSource> _expenseSources;
  String _periodSelectedValue = 'This Week';
  String _sourceExpenseFilterSelectedValue = "All";

  @override
  void initState() {
    super.initState();
    _expenses = sl<ExpenseService>().list();
    _filteredExpenses = _expenses;
    _expenseSources = sl<ExpenseSourceService>().list();
  }

  /// TODO: Replace this function later with real function
  void _addRandomExpense() {
    final random = Random();

    final randomSource =
        _expenseSources[random.nextInt(_expenseSources.length)];

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

    final subCategories =
        sl<ExpenseSubCategoryService>().listByParentId(randomCategory.id);
    if (subCategories.isNotEmpty) {
      final randomSubCategory =
          subCategories[random.nextInt(subCategories.length)];

      newExpense.subCategory = randomSubCategory;
    }

    sl<ExpenseService>().create(newExpense);

    setState(() {
      _expenses.add(newExpense);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the sum of the amounts of all expenses
    final totalAmount =
        _filteredExpenses.fold(0.0, (sum, expense) => sum + expense.amount);

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
                        value: _sourceExpenseFilterSelectedValue,
                        onChanged: (newValue) {
                          setState(() {
                            _sourceExpenseFilterSelectedValue = newValue!;
                          });

                          // Filter _filteredExpenses based on the selected source
                          if (newValue == "All") {
                            _filteredExpenses = _expenses;
                          } else {
                            _filteredExpenses = _expenses
                                .where((expense) =>
                                    expense.source.name == newValue)
                                .toList();
                          }
                        },
                        items: ["All"]
                            .followedBy(_expenseSources.map((e) => e.name))
                            .toList(),
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
                final expenses = _filteredExpenses.reversed.toList();

                // Get the reversed list of expenses
                return _buildTransactionTile(expenses[index], index);
              },
              childCount: _filteredExpenses.length,
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
        title: Text(
            "${expense.category.name}${expense.subCategory != null ? ' - ${expense.subCategory!.name}' : ''}"),
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
