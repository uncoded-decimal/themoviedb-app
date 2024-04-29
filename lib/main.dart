import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wework_challenge/src/app/views/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupHive();
  runApp(
    const App(),
  );
}

Future<void> setupHive() async {
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox('we_movies');
}
