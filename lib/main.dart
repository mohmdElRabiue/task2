import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task2/homeScreen.dart';
import 'package:task2/local_Storage/translate.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:task2/Api/translating_service.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await initHive(); 
  runApp(const MyApp());
}
Future<void> initHive() async {
  await Hive.initFlutter();
   Hive.registerAdapter(TranslateAdapter());
  // You can open boxes or register adapters here if needed
  final box = await Hive.openBox<Translate>('translationsBox');
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
  home: HomeScreen()

    );
  }
}

