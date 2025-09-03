import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/archive_controller.dart';

class ArchiveView extends StatelessWidget {
  const ArchiveView({super.key});

  @override
  Widget build(BuildContext context) {
    final archive = Provider.of<ArchiveController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Arşiv")),
      body: ListView.builder(
        itemCount: archive.archivedInvoices.length,
        itemBuilder: (context, index) {
          final f = archive.archivedInvoices[index];
          return ListTile(
            title: Text(f["title"]),
            subtitle: Text(
              "${(f["amount"] as double).toStringAsFixed(2)} ₺  •  ${f["dueDate"].toString().split(' ').first}",
            ),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          );
        },
      ),
    );
  }
}
