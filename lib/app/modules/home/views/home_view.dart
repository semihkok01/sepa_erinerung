import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sepa_erinerung/app/modules/archive/controllers/archive_controller.dart';
import '../controllers/home_controller.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final home = Provider.of<HomeController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Fatura Takip")),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: home.invoices.length,
        itemBuilder: (context, index, animation) {
          final item = home.invoices[index];
          return _buildItem(context, item, index, animation);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItem(BuildContext context, Map<String, dynamic> invoice,
      int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          title: Text(invoice["title"]),
          subtitle: Text(
            "${(invoice["amount"] as double).toStringAsFixed(2)} ₺  •  ${invoice["dueDate"].toString().split(' ').first}",
          ),
          tileColor: invoice["isPaid"] ? Colors.green[100] : Colors.red[100],
          trailing: Checkbox(
            value: invoice["isPaid"],
            onChanged: (val) {
              if (val == true) {
                _archiveWithAnimation(context, index);
              } else {
                Provider.of<HomeController>(context, listen: false)
                    .setPaid(index, false);
              }
            },
          ),
          onLongPress: () => Provider.of<HomeController>(context, listen: false)
              .deleteInvoice(index),
        ),
      ),
    );
  }

  void _archiveWithAnimation(BuildContext context, int index) {
    final home = Provider.of<HomeController>(context, listen: false);
    final archive = Provider.of<ArchiveController>(context, listen: false);

    // Önce ödenmiş olarak işaretle
    home.setPaid(index, true);

    // Veri modelinden elemanı al (notify etmeden)
    final removed = Map<String, dynamic>.from(home.takeAt(index));

    // Listeden animasyonla çıkar
    _listKey.currentState!.removeItem(
      index,
      (ctx, anim) => SlideTransition(
        position: Tween<Offset>(begin: Offset.zero, end: const Offset(1.0, 0.0))
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeIn)),
        child: Opacity(
          opacity: 0.8,
          child: _ghostTile(removed),
        ),
      ),
      duration: const Duration(milliseconds: 350),
    );

    // Animasyon bittikten sonra arşive ekle
    Future.delayed(const Duration(milliseconds: 360), () {
      archive.addToArchive(removed);
      // Home listesi AnimatedList ile senkron, ekstra notify gerekmiyor
      if (mounted) setState(() {});
    });
  }

  Widget _ghostTile(Map<String, dynamic> invoice) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(invoice["title"]),
        subtitle: Text(
          "${(invoice["amount"] as double).toStringAsFixed(2)} ₺  •  ${invoice["dueDate"].toString().split(' ').first}",
        ),
        tileColor: Colors.green[100],
        trailing: const Icon(Icons.check, color: Colors.green),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final home = Provider.of<HomeController>(context, listen: false);
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    bool everyMonth3rd = false;
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Text("Yeni Fatura Ekle"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Başlık"),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Tutar"),
                ),
                CheckboxListTile(
                  title: const Text("Her ayın 3’ünde hatırlat"),
                  value: everyMonth3rd,
                  onChanged: (val) {
                    setState(() {
                      everyMonth3rd = val ?? false;
                      if (everyMonth3rd) {
                        final now = DateTime.now();
                        selectedDate = DateTime(now.year, now.month, 3);
                      } else {
                        selectedDate = null;
                      }
                    });
                  },
                ),
                if (!everyMonth3rd)
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => selectedDate = picked);
                    },
                    child: const Text("Tarih Seç"),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("İptal"),
              ),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final amount = double.tryParse(amountController.text) ?? 0;

                  if (title.isEmpty || amount <= 0) return;
                  if (!everyMonth3rd && selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Lütfen tarih seçin.")),
                    );
                    return;
                  }

                  home.addInvoice(
                    title,
                    amount,
                    dueDate: selectedDate,
                    everyMonth3rd: everyMonth3rd,
                  );

                  // AnimatedList'e ekleme animasyonu
                  _listKey.currentState!.insertItem(
                    home.invoices.length - 1,
                    duration: const Duration(milliseconds: 250),
                  );

                  Navigator.pop(ctx);
                },
                child: const Text("Kaydet"),
              ),
            ],
          );
        },
      ),
    );
  }
}
