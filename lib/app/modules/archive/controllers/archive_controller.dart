import 'package:flutter/material.dart';

class ArchiveController extends ChangeNotifier {
  final List<Map<String, dynamic>> archivedInvoices = [];

  void addToArchive(Map<String, dynamic> invoice) {
    archivedInvoices.add(invoice);
    notifyListeners();
  }
}
