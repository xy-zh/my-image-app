import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/NewPostActivity.dart';

import 'screens/LoginPage.dart';
import 'screens/BrowsePostsActivity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
              title: 'FlutterChat',
              theme: ThemeData(
                primarySwatch: Colors.pink,
                backgroundColor: Colors.pink,
                buttonTheme: ButtonTheme.of(context).copyWith(
                  buttonColor: Colors.pink,
                  textTheme: ButtonTextTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              home: const BrowsePostsActivity(),
              // home: const HomePage(),
              initialRoute: '/',
              routes: {
                '/newPost': (context) => const NewPostActivity(),
                '/session': (context) => const LoginPage(),
              });
        });
  }
}
