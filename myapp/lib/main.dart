import 'package:flutter/material.dart';
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
      title: 'Pathfinder Odyssey',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.green,
      ),
      // リスト一覧画面を表示
      home: TodoListPage(title: 'My App'),
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
// ignore: must_be_immutable
class TodoListPage extends StatelessWidget {
  TodoListPage({super.key, required this.title});

  final String title;

  //入力されたテキストを受け取る
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pathfinder Odyssey'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(children: <Widget>[
          const SizedBox(height: 120),
          TextField(
            controller: myController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '検索したい場所を入力してください',
            ),
          ),
          TextButton(
            child: const Text('検索'),
            onPressed: () async {
              print(myController.text);
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
