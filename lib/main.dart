import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login/pages/landing_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: const ColorScheme.light(
          primary: Color.fromRGBO(0, 128, 255, 1),
          onPrimary: Colors.white,
          secondary: Color.fromRGBO(115, 194, 251, 1),
          onSecondary: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(0, 128, 255, 1),
          onPrimary: Colors.black,
          secondary: Color.fromRGBO(0, 0, 128, 1),
          onSecondary: Colors.black,
        ),
      ),
      routes: {
        '/landing': (context) => const LandingPage(),
      },
      initialRoute: '/landing',
    );
  }
}
