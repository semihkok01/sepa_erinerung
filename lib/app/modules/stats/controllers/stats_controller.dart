import 'package:flutter/material.dart';

class StatsController extends ChangeNotifier {
  final List<Map<String, dynamic>> archivedInvoices;

  StatsController(this.archivedInvoices);

  double get totalPaid =>
      archivedInvoices.fold(0, (sum, f) => sum + (f["amount"] as double));

  Map<String, double> monthlyTotals() {
    Map<String, double> result = {};
    for (var f in archivedInvoices) {
      final date = f["dueDate"] as DateTime;
      final key = "${date.year}-${date.month}";
      result[key] = (result[key] ?? 0) + (f["amount"] as double);
    }
    return result;
  }
}
