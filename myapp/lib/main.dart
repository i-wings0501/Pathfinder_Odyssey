import 'package:flutter/material.dart';
import 'package:myapp/get_gps.dart';

void main() {
  // 最初に表示するWidget
  runApp(const TopPage());
}

//top画面
class TopPage extends StatelessWidget {
  const TopPage({super.key});

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
      home: TopPageTodo(title: 'My App'),
    );
  }
}

// リスト一覧画面用Widget
// class TopPageTodo extends StatelessWidget {
//   const TopPageTodo({super.key});

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

//top画面のwidget
// ignore: must_be_immutable
class TopPageTodo extends StatelessWidget {
  TopPageTodo({super.key, required this.title});

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
        child: Padding(
          // テキストフィールドのpadding
          padding: const EdgeInsets.all(20),
          child: Column(
              //中央配置
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //テキストフィールド
                TextField(
                  //入力されたテキスト
                  controller: myController,
                  //テキストフィールドの装飾
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '検索したい場所を入力してください',
                  ),
                ),
                //検索ボタン
                ElevatedButton(
                  child: const Text('検索'),
                  onPressed: () async {
                    //新しい画面に遷移;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //遷移先の画面に入力されたテキストを渡す
                        builder: (context) => SerchPage(myController.text),
                      ),
                    );
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) {
                    //     return const SerchPage();
                    //   }),
                    // );
                  },
                ),
              ]),
        ),
      ),
    );
  }
}
