import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'transaction_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: MaterialApp(
        title: 'Personal Finance Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          //accentColor: Colors.deepPurple,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.teal,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Finance Tracker')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Total Balance: ₹${provider.totalBalance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.getMonthlyData().keys.length,
              itemBuilder: (context, index) {
                final month = provider.getMonthlyData().keys.toList()[index];
                final income = provider.getMonthlyData()[month]!['income'] ?? 0.0;
                final expense = provider.getMonthlyData()[month]!['expense'] ?? 0.0;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      month,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Income: ₹${income.toStringAsFixed(2)} | Expense: ₹${expense.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: Icon(
                      income > expense ? Icons.arrow_upward : Icons.arrow_downward,
                      color: income > expense ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    bool isIncome = true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                const Text('Type: '),
                DropdownButton<bool>(
                  value: isIncome,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Income')),
                    DropdownMenuItem(value: false, child: Text('Expense')),
                  ],
                  onChanged: (value) {
                    isIncome = value ?? true;
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final title = titleController.text;
              final amount = double.tryParse(amountController.text) ?? 0.0;
              if (title.isNotEmpty && amount > 0) {
                provider.addTransaction(title, amount, isIncome);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
