import 'package:cybersec_news/home.dart';
import 'package:cybersec_news/provider/hn_provider.dart';
import 'package:cybersec_news/utility/firebase_options.dart';
import 'package:cybersec_news/utility/local_storage_schematic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  Hive.registerAdapter(LocalStorageSchematicAdapter());
  await Hive.openBox('apiResponse');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HnProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Cybersec News',
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
