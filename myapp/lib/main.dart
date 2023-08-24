import 'package:flutter/material.dart';
import 'package:myapp/top_page.dart';

void main() {
  // 最初に表示するWidget
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'Pathfinder Odyssey',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.green,
      ),
      // リスト一覧画面を表示
      home: TopPage(),
    );
  }
}
