import 'package:explension/constants.dart';
import 'package:flutter/material.dart';

class CalculatorKeyboard extends StatelessWidget {
  final Function(String) onButtonPressed;

  const CalculatorKeyboard({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber,
        ),
        child: Column(
          children: [
            _buildRow(['1', '2', '3', '/']),
            _buildRow(['4', '5', '6', '*']),
            _buildRow(['7', '8', '9', '-']),
            _buildRow(['0', '000', '<', '+']),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> texts) {
    return Expanded(
      child: Row(
        children: texts
            .map((text) => CalculatorButton(
                  text: text,
                  onPressed: (text == '<')
                      ? () => onButtonPressed('Backspace')
                      : () => onButtonPressed(text),
                ))
            .toList(),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const CalculatorButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        padding: EdgeInsets.all(paddingSize),
        height: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}
