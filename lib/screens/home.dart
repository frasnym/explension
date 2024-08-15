import 'package:explension/models/expense.dart';
import 'package:explension/models/wallet.dart';
import 'package:explension/services/expense.dart';
import 'package:explension/services/expense_source.dart';
import 'package:explension/utils/random_expense_generator.dart';
import 'package:explension/widgets/home/custom_dropdown.dart';
import 'package:explension/widgets/home/transaction_tile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final ExpenseService expenseService;
  final WalletService walletService;

  const HomePage({
    super.key,
    required this.expenseService,
    required this.walletService,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Stream to listen for changes in the list of expenses
  late Stream<List<Expense>> _expensesStream;

  // List of all wallet
  late List<Wallet> _wallets;

  // Currently selected period for the expense filter
  String _periodSelectedValue = 'All';

  // Currently selected wallet for the expense filter
  String _walletFilterSelectedValue = "All";

  @override
  void initState() {
    super.initState();
    // Initialize the expenses stream and the list of expense sources
    _expensesStream = widget.expenseService.stream();
    _wallets = widget.walletService.list();
  }

  // Method to add a random expense for testing purposes
  void _addExpense() {
    // TODO: Replace later with actual expense creation
    widget.expenseService.create(generateRandomExpense());
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
            if (_periodSelectedValue == "All") {
              return true;
            } else if (_periodSelectedValue == "This Week") {
              final now = DateTime.now();
              final weekStart = now.subtract(Duration(days: now.weekday - 1));
              return expense.createdAt.isAfter(weekStart);
            } else if (_periodSelectedValue == "This Month") {
              final now = DateTime.now();
              final monthStart = DateTime(now.year, now.month, 1);
              return expense.createdAt.isAfter(monthStart);
            } else if (_periodSelectedValue == "This Year") {
              final now = DateTime.now();
              final yearStart = DateTime(now.year, 1, 1);
              return expense.createdAt.isAfter(yearStart);
            } else {
              return true;
            }
          }).where((expense) {
            if (_walletFilterSelectedValue == "All") {
              return true;
            } else {
              return expense.wallet.name == _walletFilterSelectedValue;
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
                              items: const [
                                'All',
                                'This Week',
                                'This Month',
                                'This Year'
                              ],
                              onChanged: (newValue) {
                                setState(() {
                                  _periodSelectedValue = newValue!;
                                });
                              },
                              value: _periodSelectedValue,
                            ),
                            const SizedBox(width: 20),
                            CustomDropdown(
                                value: _walletFilterSelectedValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _walletFilterSelectedValue = newValue!;
                                  });
                                },
                                items: ["All"]
                                    .followedBy(_wallets.map((e) => e.name))
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
