import 'package:flutter/material.dart';
import 'package:medrecs/util/model/theme_model.dart';
import 'package:medrecs/util/model/user_data.dart';
import 'package:medrecs/views/commonView/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'configs/firebase_options.dart';
import 'package:provider/provider.dart';  // Import the provider package


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserData()),
        ChangeNotifierProvider(create: (context) => ThemeModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedRecs',
      theme: themeModel.currentTheme,
      home: const LoginScreen(),
    );
  }
}
