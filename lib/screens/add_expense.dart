import 'package:explension/models/category.dart';
import 'package:explension/models/expense.dart';
import 'package:explension/models/wallet.dart';
import 'package:explension/services/category.dart';
import 'package:explension/services/sub_category.dart';
import 'package:explension/services/wallet.dart';
import 'package:flutter/material.dart';
import 'package:explension/services/expense.dart';
import 'package:explension/injector.dart';

class AddExpensePage extends StatefulWidget {
  final ExpenseService expenseService = sl<ExpenseService>();
  final WalletService walletService = sl<WalletService>();
  final CategoryService categoryService = sl<CategoryService>();
  final SubCategoryService subCategoryService = sl<SubCategoryService>();

  AddExpensePage({
    super.key,
  });

  @override
  AddExpensePageState createState() => AddExpensePageState();
}

class AddExpensePageState extends State<AddExpensePage> {
  late List<Wallet> _wallets;
  late List<Category> _categories;
  List<Category> _subCategories = [];

  @override
  void initState() {
    super.initState();

    // Initialize the expenses stream and the list of expense sources
    _wallets = widget.walletService.list();
    _categories = widget.categoryService.list();
  }

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController(text: "");
  final noteController = TextEditingController(text: "");
  Category? category;
  Category? subCategory;
  Wallet? wallet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Expense'),
        ),
        body: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<Category>(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      hintText: 'Select the category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    value: category,
                    items: _categories.map((Category value) {
                      return DropdownMenuItem<Category>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (Category? newValue) {
                      if (newValue == null) return;
                      setState(() {
                        category = newValue;

                        final subCats = widget.subCategoryService
                            .listByParentId(newValue.key);
                        if (subCats.isNotEmpty) {
                          _subCategories = subCats;
                        } else {
                          _subCategories = [];
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                ),
                _subCategories.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DropdownButtonFormField<Category>(
                          decoration: const InputDecoration(
                            labelText: 'Sub Category',
                            hintText: 'Select the category',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          value: subCategory,
                          items: _subCategories.map((Category value) {
                            return DropdownMenuItem<Category>(
                              value: value,
                              child: Text(value.name),
                            );
                          }).toList(),
                          onChanged: (Category? newValue) {
                            setState(() {
                              subCategory = newValue;
                            });
                          },
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      hintText: 'Enter the amount',
                      prefixText: "IDR ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null) {
                        return 'Please enter a valid number';
                      }
                      if (amount <= 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<Wallet>(
                    decoration: const InputDecoration(
                      labelText: 'Wallet',
                      hintText: 'Select the wallet',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    value: wallet,
                    items: _wallets.map((Wallet value) {
                      return DropdownMenuItem<Wallet>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (Wallet? newValue) {
                      if (newValue == null) return;
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Note',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    controller: noteController,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      // Create a new Expense object
                      Expense newExpense = Expense(
                        amount: double.parse(amountController.text),
                        category: category!,
                        subCategory: subCategory,
                        wallet: wallet!,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        note: noteController.text,
                      );

                      // Add the new expense to your data source
                      widget.expenseService.create(newExpense);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'),
                )
              ],
            ),
          ),
        ));
  }
}
