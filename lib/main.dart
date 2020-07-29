import 'package:flutter/material.dart';
import './server.dart';
import 'login_page.dart';
import 'package:path_provider/path_provider.dart';

String dir;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dir = (await getApplicationDocumentsDirectory()).path;
  startServer();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
