import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  final List<Map<String, dynamic>> invoices = [];

  void addInvoice(
    String title,
    double amount, {
    DateTime? dueDate,
    bool everyMonth3rd = false,
  }) {
    invoices.add({
      "title": title,
      "amount": amount,
      "dueDate": dueDate ?? DateTime.now(),
      "isPaid": false,
      "everyMonth3rd": everyMonth3rd,
    });
    notifyListeners();
  }

  // Sadece işaret durumunu değiştir (listeyi silme/ekleme yok)
  void setPaid(int index, bool paid) {
    invoices[index]["isPaid"] = paid;
    notifyListeners();
  }

  // Animasyon için: notify çağırmadan elemanı veri kaynağından çıkar ve geri döndür
  Map<String, dynamic> takeAt(int index) {
    return invoices.removeAt(index);
  }

  // Normal silme (yeniden çizim gereken yerlerde)
  void deleteInvoice(int index) {
    invoices.removeAt(index);
    notifyListeners();
  }
}
