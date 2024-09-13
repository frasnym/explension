import 'package:explension/constants.dart';
import 'package:explension/models/category.dart';
import 'package:explension/models/expense.dart';
import 'package:explension/models/wallet.dart';
import 'package:explension/screens/add_expense/amount_input.dart';
import 'package:explension/services/category.dart';
import 'package:explension/services/sub_category.dart';
import 'package:explension/services/wallet.dart';
import 'package:explension/widgets/ui/input/select_input.dart';
import 'package:flutter/material.dart';
import 'package:explension/services/expense.dart';
import 'package:explension/injector.dart';
import 'package:moon_design/moon_design.dart';

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
  late List<Wallet> _walletOptions;
  late List<Category> _categoryOptions;
  List<Category> _subCategoryOptions = [];

  @override
  void initState() {
    super.initState();

    // Initialize the expenses stream and the list of expense sources
    _walletOptions = widget.walletService.list();
    _categoryOptions = widget.categoryService.list();

    // TODO: Delete later, for dev only
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToCalculatorInput();
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController(text: "");
  final _noteController = TextEditingController(text: "");
  Category? _selectedCategory;
  Category? _selectedSubCategory;
  Wallet? _selectedWallet;

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
            borderRadius: BorderRadius.circular(kDefaultRadius),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: kDefaultPadding),
                  child: SelectInput(
                    placeholder: "Select Category",
                    optionsList: _categoryOptions.map((c) => c.name).toList(),
                    onChange: (newVal) => {
                      setState(() {
                        _selectedCategory = _categoryOptions
                            .firstWhere((element) => element.name == newVal);

                        final subCats = widget.subCategoryService
                            .listByParentId(_selectedCategory!.key);
                        if (subCats.isNotEmpty) {
                          _subCategoryOptions = subCats;
                        } else {
                          _subCategoryOptions = [];
                        }
                      })
                    },
                  ),
                ),
                _subCategoryOptions.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding),
                        child: SelectInput(
                          placeholder: "Select Sub-Category",
                          optionsList:
                              _subCategoryOptions.map((c) => c.name).toList(),
                          onChange: (newVal) => {
                            setState(() {
                              _selectedSubCategory =
                                  _subCategoryOptions.firstWhere(
                                      (element) => element.name == newVal);
                            })
                          },
                        ),
                      )
                    : Container(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: kDefaultPadding),
                  child: MoonFormTextInput(
                    controller: _amountController,
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter amount';
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
                    onTap: _navigateToCalculatorInput,
                    hintText: "Enter the amount",
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: kDefaultPadding),
                  child: SelectInput(
                    placeholder: "Select Wallet",
                    optionsList: _walletOptions.map((c) => c.name).toList(),
                    onChange: (newVal) => {
                      setState(() {
                        _selectedWallet = _walletOptions
                            .firstWhere((element) => element.name == newVal);
                      })
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: kDefaultPadding),
                  child: MoonFormTextInput(
                    controller: _noteController,
                    hintText: "Enter the note",
                  ),
                ),
                const SizedBox(height: kDefaultPadding * 2),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // Create a new Expense object
                      Expense newExpense = Expense(
                        amount: double.parse(_amountController.text),
                        category: _selectedCategory!,
                        subCategory: _selectedSubCategory,
                        wallet: _selectedWallet!,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        note: _noteController.text,
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

  void _navigateToCalculatorInput() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AmountInput(amountController: _amountController),
      ),
    );
  }
}
