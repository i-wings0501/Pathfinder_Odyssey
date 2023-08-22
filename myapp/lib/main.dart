import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
import 'package:myapp/get_gps.dart';

void main() {
  // 最初に表示するWidget
  runApp(const MyTodoApp());
}

//top画面
class MyTodoApp extends StatelessWidget {
  const MyTodoApp({super.key});

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
      home: const TodoListPage(),
    );
  }
}

// リスト一覧画面用Widget
// class TodoListPage extends StatelessWidget {
//   const TodoListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: const Center(
//         child: Text('GPS情報の取得'),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // "push"で新規画面に遷移
//           Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) {
//               // 遷移先の画面としてリスト追加画面を指定
//               return const MyGPS();
//             }),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

//top画面home:TodoListPage()の画面
class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS情報'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(children: <Widget>[
          const SizedBox(height: 120),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '検索したい場所を入力してください',
            ),
            onChanged: (text) {
              //入力されたテキストを受け取る
              var inputText = text;
              //入力されたテキストをデバッグエリアに表示
              print(inputText);
            },
          ),
          TextButton(
            child: const Text('検索'),
            onPressed: () async {
              //新しい画面にresponse.bodyを表示する;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return const FutureBuilderPage();
                }),
              );
            },
          ),
        ]),
      ),
    );
  }
}
