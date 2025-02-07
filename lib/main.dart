import 'package:flutter/material.dart';
import 'package:maze/models/MazeData.dart';
import 'package:maze/screens/MazePage.dart';

void main() {
//  MazeData().load(); //ここではprefsが取れない
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: 'Maze',
    theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Hiragino Sans',
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff55c500),
        ),
        textTheme: Theme.of(context).textTheme.apply(
        fontSizeFactor: 1.2,
        fontSizeDelta: 4.0,
            bodyColor: Colors.black,
        ),
    ),
    home: MazePage(),
    );
  }
}
