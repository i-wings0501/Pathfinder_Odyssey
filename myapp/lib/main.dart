import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  // 最初に表示するWidget
  runApp(MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'My Todo App',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
      ),
      // リスト一覧画面を表示
      home: TodoListPage(),
    );
  }
}

// リスト一覧画面用Widget
class TodoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('GPS情報の取得'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // "push"で新規画面に遷移
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面としてリスト追加画面を指定
              return MyGPS();
            }),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

//GPS情報を取得する
class MyGPS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS情報'),
      ),
      body: Center(
        child: TextButton(
          child: const Text('近くのお店を検索'),
          onPressed: () async {
            //現在のGPS情報を取得する
            final position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            print(position);
          },
        ),
      ),
    );
  }
}
