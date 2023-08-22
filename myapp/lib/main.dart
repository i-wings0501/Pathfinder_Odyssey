import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() {
  // 最初に表示するWidget
  runApp(const MyTodoApp());
}

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

//GPS情報を取得する
class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

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
            //新しい画面にresponse.bodyを表示する;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return const FutureBuilderPage();
              }),
            );
          },
        ),
      ),
    );
  }
}

class FutureBuilderPage extends StatefulWidget {
  const FutureBuilderPage({super.key});

  @override
  State<FutureBuilderPage> createState() => serchPage();
}

class serchPage extends State<FutureBuilderPage> {
  late Future<String> future;

  //localhost:3000のサーバーにhttp通信で現在地を送信する関数
  _getMYgps() async {
    //現在地を取得する
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //現在地の緯度を取得する
    final latitude = position.latitude.toString();
    //現在地の経度を取得する
    final longitude = position.longitude.toString();

    //laitudeとlongitudeをreturnする
    return [latitude, longitude];
  }

  Future<String> http_post() async {
    //200--success
    var gps = await _getMYgps();
    var response = await http.post(
        Uri.parse("http://localhost:3000/gps?lat=${gps[0]}&lon=${gps[1]}"));
    //「緯度：latitude,経度：longitude」をprintする
    print("緯度：${gps[0]}、経度：${gps[1]}}");
    return (response.body);
  }

  @override
  void initState() {
    super.initState();
    future = Future(() async {
      return await http_post();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS情報'),
      ),
      body: Center(
        child: FutureBuilder(
          future: future,
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
