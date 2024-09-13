import 'package:explension/constants.dart';
import 'package:explension/utils/money.dart';
import 'package:explension/widgets/ui/input/calculator_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class AmountInput extends StatefulWidget {
  final TextEditingController amountController;

  const AmountInput({super.key, required this.amountController});

  @override
  AmountInputState createState() => AmountInputState();
}

class AmountInputState extends State<AmountInput> {
  late final _equationController = TextEditingController();
  var _isShowEquationInput = false;

  @override
  void initState() {
    super.initState();
    _equationController.text = widget.amountController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator Input')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(kDefaultRadius),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Rp ${formatMoneyString(widget.amountController.text)}",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    _isShowEquationInput
                        ? Text(
                            _equationController.text
                                .split(RegExp(r'[+\-*/]'))
                                .map((number) {
                              final parsedNumber = num.tryParse(number);
                              return parsedNumber != null
                                  ? formatMoney(parsedNumber)
                                  : '';
                            }).join(_equationController.text
                                        .contains(RegExp(r'[+\-*/]'))
                                    ? _equationController.text
                                        .split(RegExp(r'\d+'))[1]
                                    : ''),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            CalculatorKeyboard(
              onButtonPressed: (String value) {
                setState(() {
                  if (value == calculatorDeleteValue) {
                    _handleBackspace();
                  } else {
                    _oneOperatorGuard(value);

                    // Guard: Do nothing if equation to zero
                    if (value == "0" || value == "000") {
                      final lastChar = _equationController.text.isNotEmpty
                          ? _equationController.text
                              .substring(_equationController.text.length - 1)
                          : "";
                      if (_isOnlyOperator(lastChar) || lastChar.isEmpty) {
                        return;
                      }
                    }

                    _equationController.text += value;
                  }

                  // Error Guard: Do nothing if input is OR only operator
                  if (_equationController.text.isEmpty ||
                      _isOnlyOperator(_equationController.text)) {
                    _equationController.text = "";
                    widget.amountController.text = "";
                    return;
                  }

                  _calculateIsShowEquationInput();
                  _evaluateExpression();
                });
              },
            ),
            Container(
              padding: const EdgeInsets.only(top: kDefaultPadding),
              child: ElevatedButton(
                onPressed: double.tryParse(widget.amountController.text) !=
                            null &&
                        double.parse(widget.amountController.text) > 0
                    ? () => {
                          Navigator.pop(context, widget.amountController.text),
                        }
                    : null,
                child: const Text('Submit Amount'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _countOperator(String equation) {
    return equation.split(RegExp(r'[+\-*/]')).length - 1;
  }

  bool _isOnlyOperator(String equation) {
    return RegExp(r'^[+\-*/]$').hasMatch(equation);
  }

  void _oneOperatorGuard(String value) {
    final isNextValueIsOperator = RegExp(r'^[+\-*/]$').hasMatch(value);
    if (_countOperator(_equationController.text) >= 1 &&
        isNextValueIsOperator) {
      _evaluateExpression();
      _equationController.text = widget.amountController.text;
    }
  }

  void _calculateIsShowEquationInput() {
    if (_countOperator(_equationController.text) > 0) {
      _isShowEquationInput = true;
    } else {
      _isShowEquationInput = false;
    }
  }

  void _handleBackspace() {
    if (_equationController.text.isNotEmpty) {
      _equationController.text = _equationController.text
          .substring(0, _equationController.text.length - 1);
    }
  }

  void _evaluateExpression() {
    try {
      // Calculate the result using math_expressions package
      final expression = Parser().parse(_equationController.text);
      final result = expression.evaluate(EvaluationType.REAL, ContextModel());

      // Round up the result to number no decimal
      final roundedResult = result.toDouble().ceil();
      widget.amountController.text = roundedResult.toString();
    } catch (e) {
      // Remove all operators from _equationController.text if error occurs
      final cleanEquation =
          _equationController.text.replaceAll(RegExp(r'[^\d]'), '');
      widget.amountController.text = cleanEquation;
    }
  }
}
