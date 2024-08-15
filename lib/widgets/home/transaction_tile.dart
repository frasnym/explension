import 'package:flutter/material.dart';
import 'package:explension/models/expense.dart';

class TransactionTile extends StatelessWidget {
  final Expense expense;
  final int index;

  const TransactionTile(
      {super.key, required this.expense, required this.index});

  @override
  Widget build(BuildContext context) {
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
              expense.wallet.name,
            ),
          ],
        ),
      ),
    );
  }
}
