import 'package:flutter/material.dart';
import './server.dart';
import 'login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

String dir;
const darkModeBox = 'darkModeState';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(darkModeBox);
  dir = (await getApplicationDocumentsDirectory()).path;
  startServer();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(darkModeBox).listenable(),
      builder: (context, box, widget) {
        var darkMode = box.get('darkMode', defaultValue: false);
        return MaterialApp(
            themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
            darkTheme: ThemeData.dark(),
            home: LoginPage());
      },
    );
  }
}
