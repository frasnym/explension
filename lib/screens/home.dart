import 'package:explension/models/expense.dart';
import 'package:explension/models/expense_source.dart';
import 'package:explension/services/expense.dart';
import 'package:explension/services/expense_source.dart';
import 'package:explension/utils/random_expense_generator.dart';
import 'package:explension/widgets/home/custom_dropdown.dart';
import 'package:explension/widgets/home/transaction_tile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final ExpenseService expenseService;
  final ExpenseSourceService expenseSourceService;

  const HomePage({
    super.key,
    required this.expenseService,
    required this.expenseSourceService,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Stream to listen for changes in the list of expenses
  late Stream<List<Expense>> _expensesStream;

  // List of all expense sources
  late List<ExpenseSource> _expenseSources;

  // Currently selected period for the expense filter
  String _periodSelectedValue = 'This Week';

  // Currently selected source for the expense filter
  String _sourceExpenseFilterSelectedValue = "All";

  @override
  void initState() {
    super.initState();
    // Initialize the expenses stream and the list of expense sources
    _expensesStream = widget.expenseService.stream();
    _expenseSources = widget.expenseSourceService.list();
  }

  // Method to add a random expense for testing purposes
  void _addExpense() {
    // TODO: Replace later with actual expense creation
    widget.expenseService.create(generateRandomExpense(_expenseSources));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
      stream: _expensesStream,
      initialData: widget.expenseService.list(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final expenses = snapshot.data!;
          final filteredExpenses = expenses.where((expense) {
            if (_sourceExpenseFilterSelectedValue == "All") {
              return true;
            } else {
              return expense.source.name == _sourceExpenseFilterSelectedValue;
            }
          }).toList();

          final totalAmount = filteredExpenses.fold(
              0.0, (sum, expense) => sum + expense.amount);

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
                            CustomDropdown(
                              items: ['This Week', 'This Month', 'This Year'],
                              onChanged: (newValue) {
                                setState(() {
                                  _periodSelectedValue = newValue!;
                                });
                              },
                              value: _periodSelectedValue,
                            ),
                            const SizedBox(width: 20),
                            CustomDropdown(
                                value: _sourceExpenseFilterSelectedValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _sourceExpenseFilterSelectedValue =
                                        newValue!;
                                  });
                                },
                                items: ["All"]
                                    .followedBy(
                                        _expenseSources.map((e) => e.name))
                                    .toList())
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return TransactionTile(
                          expense: filteredExpenses[index], index: index);
                    },
                    childCount: filteredExpenses.length,
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _addExpense();
              },
              tooltip: 'Add Expense',
              child: const Icon(Icons.add),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
