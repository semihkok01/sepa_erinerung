import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sepa_erinerung/app/modules/archive/controllers/archive_controller.dart';


class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final archive = Provider.of<ArchiveController>(context);
    final total = archive.archivedInvoices.fold<double>(
      0,
      (sum, f) => sum + (f["amount"] as double),
    );

    final monthly = <String, double>{};
    for (final f in archive.archivedInvoices) {
      final d = f["dueDate"] as DateTime;
      final key = "${d.year}-${d.month.toString().padLeft(2, '0')}";
      monthly[key] = (monthly[key] ?? 0) + (f["amount"] as double);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("İstatistikler")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Toplam Ödenen: ${total.toStringAsFixed(2)} ₺",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text("Aylık Toplamlar:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: monthly.entries
                    .map((e) => ListTile(
                          leading: const Icon(Icons.calendar_month),
                          title: Text(e.key),
                          trailing: Text("${e.value.toStringAsFixed(2)} ₺"),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
