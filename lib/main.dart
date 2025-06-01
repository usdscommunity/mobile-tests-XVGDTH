import 'package:flutter/material.dart';
import 'package:selection_lead_concours/db/isar_service.dart';
import 'package:selection_lead_concours/splash/view/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Isar
  await isarService.initializeIsar();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Splash(),
    );
  }
}
