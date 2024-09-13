import 'package:explension/constants.dart';
import 'package:flutter/material.dart';

class CalculatorKeyboard extends StatelessWidget {
  final Function(String) onButtonPressed;

  const CalculatorKeyboard({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 2),
      height: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRow(['1', '2', '3', '/']),
          _buildRow(['4', '5', '6', '*']),
          _buildRow(['7', '8', '9', '-']),
          _buildRow(['0', '000', '<', '+']),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> texts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: texts
          .map((text) => CalculatorButton(
                text: text,
                onPressed: (text == '<')
                    ? () => onButtonPressed(calculatorDeleteValue)
                    : () => onButtonPressed(text),
              ))
          .toList(),
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
    var size = MediaQuery.of(context).size.width / 4.7;
    return SizedBox(
      height: size,
      width: size,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
