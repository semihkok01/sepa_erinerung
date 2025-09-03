import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sepa_erinerung/app/modules/archive/controllers/archive_controller.dart';
import 'package:sepa_erinerung/app/modules/archive/views/archive_view.dart';
import 'package:sepa_erinerung/app/modules/home/controllers/home_controller.dart';  
import 'package:sepa_erinerung/app/modules/home/views/home_view.dart';
import 'package:sepa_erinerung/app/modules/stats/views/stats_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _index = 0;

  final pages = const [
    HomeView(),
    ArchiveView(),
    StatsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => ArchiveController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fatura Takip',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        home: Scaffold(
          body: pages[_index],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Ana Sayfa'),
              NavigationDestination(icon: Icon(Icons.archive), label: 'Arşiv'),
              NavigationDestination(icon: Icon(Icons.bar_chart), label: 'İstatistik'),
            ],
          ),
        ),
      ),
    );
  }
}
