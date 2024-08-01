import 'package:explension/constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _periodSelectedValue = 'This Week';
  String _walletSelectedValue = 'Cash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: true,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildDropdown(
                    value: _periodSelectedValue,
                    onChanged: (newValue) {
                      setState(() {
                        _periodSelectedValue = newValue!;
                      });
                    },
                    items: ['This Week', 'This Month', 'This Year'],
                  ),
                  const SizedBox(width: 20),
                  _buildDropdown(
                    value: _walletSelectedValue,
                    onChanged: (newValue) {
                      setState(() {
                        _walletSelectedValue = newValue!;
                      });
                    },
                    items: ['Cash', 'Credit Card'],
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _buildTransactionTile(index);
              },
              childCount: 20,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add expense page
          print('Navigate to add expense page');
        },
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required void Function(String?) onChanged,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionTile(int index) {
    final transaction = {
      'date': '2024-07-28',
      'description': 'Transaction $index',
      'amount': index % 2 == 0 ? -100.00 : 100.00,
    };

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        width: 100,
        child: const Placeholder(),
      ),
      title: Text(transaction['description'] as String),
      subtitle: Text(transaction['date'] as String),
      trailing: Text(
        '\$${(transaction['amount'] as double).toStringAsFixed(2)}',
        style: TextStyle(
          color:
              (transaction['amount'] as double) < 0 ? Colors.red : Colors.green,
        ),
      ),
    );
  }
}
