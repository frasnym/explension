import 'package:explension/constants.dart';
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
            TextFormField(
              controller: widget.amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            _isShowEquationInput
                ? TextFormField(
                    controller: _equationController,
                    decoration: const InputDecoration(labelText: 'Equation'),
                    keyboardType: TextInputType.number,
                  )
                : Container(),
            const SizedBox(height: 100),
            CalculatorKeyboard(
              onButtonPressed: (String value) {
                setState(() {
                  if (value == 'Backspace') {
                    _handleBackspace();
                  } else {
                    _equationController.text += value;
                    _evaluateExpression();
                  }
                });
              },
            ),
            Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              padding: const EdgeInsets.all(paddingSize),
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

  void _handleBackspace() {
    if (_equationController.text.isNotEmpty) {
      _equationController.text = _equationController.text
          .substring(0, _equationController.text.length - 1);
      _evaluateExpression();
    }
  }

  void _evaluateExpression() {
    try {
      final isOnlyOperator =
          RegExp(r'^[+\-*/]$').hasMatch(_equationController.text);

      // Do nothing if input is OR only operator
      if (_equationController.text.isEmpty || isOnlyOperator) {
        _equationController.text = "";
        widget.amountController.text = "";
        return;
      }

      final operatorCount =
          _equationController.text.split(RegExp(r'[+\-*/]')).length - 1;
      if (operatorCount > 0) {
        _isShowEquationInput = true;
      } else {
        _isShowEquationInput = false;
      }

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
