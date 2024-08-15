import 'package:explension/models/category.dart';
import 'package:explension/models/expense.dart';
import 'package:explension/models/wallet.dart';
import 'package:explension/services/category.dart';
import 'package:explension/services/expense.dart';
import 'package:explension/services/sub_category.dart';
import 'package:explension/services/wallet.dart';
import 'package:explension/widgets/home/custom_dropdown.dart';
import 'package:explension/widgets/home/transaction_tile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final ExpenseService expenseService;
  final WalletService walletService;
  final CategoryService categoryService;
  final SubCategoryService subCategoryService;

  const HomePage({
    super.key,
    required this.expenseService,
    required this.walletService,
    required this.categoryService,
    required this.subCategoryService,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<List<Expense>> _expensesStream;

  // List of all wallet
  late List<Wallet> _wallets;
  late List<Category> _categories;

  String _periodSelectedValue = 'All';
  String _walletFilterSelectedValue = "All";

  @override
  void initState() {
    super.initState();
    // Initialize the expenses stream and the list of expense sources
    _expensesStream = widget.expenseService.stream();
    _wallets = widget.walletService.list();
    _categories = widget.categoryService.list();
  }

  // Method to add a random expense for testing purposes
  void _addExpense() {
    final formKey = GlobalKey<FormState>();
    String amount = '';
    Category? category;
    Category? subCategory;
    Wallet? wallet;
    String note = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a Transaction'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    amount = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<Category>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  value: category,
                  items: _categories.map((Category value) {
                    return DropdownMenuItem<Category>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                  onChanged: (Category? newValue) {
                    setState(() {
                      category = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                // TODO: Select sub-category based on category
                DropdownButtonFormField<Wallet>(
                  decoration: const InputDecoration(labelText: 'Wallet'),
                  value: wallet,
                  items: _wallets.map((Wallet value) {
                    return DropdownMenuItem<Wallet>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                  onChanged: (Wallet? newValue) {
                    setState(() {
                      wallet = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a wallet';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Note'),
                  onSaved: (value) {
                    note = value!;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  // Create a new Expense object
                  Expense newExpense = Expense(
                    amount: double.parse(amount),
                    category: category!,
                    subCategory: subCategory,
                    wallet: _wallets[0],
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    note: note,
                  );

                  // Add the new expense to your data source
                  widget.expenseService.create(newExpense);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
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
