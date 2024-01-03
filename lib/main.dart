import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/routes.dart';
import 'package:smart_home/views/auth/login.dart';
import 'package:smart_home/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: getPages(context),
      home: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}
