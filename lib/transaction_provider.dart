import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  final List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  double get totalBalance {
    double balance = 0.0;
    for (var transaction in _transactions) {
      balance += (transaction.isIncome ? transaction.amount : -transaction.amount);
    }
    return balance;
  }

  void addTransaction(String title, double amount, bool isIncome) {
    final transaction = TransactionModel(
      title: title,
      amount: amount,
      isIncome: isIncome,
      date: DateTime.now(),
    );
    _transactions.add(transaction);
    notifyListeners();
  }

  Map<String, Map<String, double>> getMonthlyData() {
    Map<String, Map<String, double>> monthlyData = {};

    for (var transaction in _transactions) {
      String month = DateFormat('MMM yyyy').format(transaction.date);

      if (monthlyData[month] == null) {
        monthlyData[month] = {'income': 0.0, 'expense': 0.0};
      }

      if (transaction.isIncome) {
        monthlyData[month]!['income'] = (monthlyData[month]!['income'] ?? 0.0) + transaction.amount;
      } else {
        monthlyData[month]!['expense'] = (monthlyData[month]!['expense'] ?? 0.0) + transaction.amount;
      }
    }

    return monthlyData;
  }

  List<TransactionModel> getTransactionsForMonth(String month) {
    return _transactions.where((transaction) {
      final transactionMonth = DateFormat('MMM yyyy').format(transaction.date);
      return transactionMonth == month;
    }).toList();
  }
}
