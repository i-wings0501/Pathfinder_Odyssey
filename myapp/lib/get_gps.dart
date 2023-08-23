import 'package:flutter/material.dart ';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

//検索結果表示画面
class SerchPage extends StatefulWidget {
  //前の画面から受け取った値を格納する変数:purpose
  SerchPage(this.purpose);
  final String purpose;

  @override
  //SerchPageTodoを返す
  //SerchPageTodoにpurposeを渡す
  State<SerchPage> createState() => SerchPageTodo(purpose);
}

//検索結果表示画面のwidget
class SerchPageTodo extends State<SerchPage> {
  //SerchPageから受け取った値を格納する変数:purpose
  SerchPageTodo(this.purpose);
  final String purpose;

  late Future<String> future;

  //現在地を取得する関数
  _getMYgps() async {
    //現在地を取得する
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //現在地の緯度を取得する
    final latitude = position.latitude.toString();
    //現在地の経度を取得する
    final longitude = position.longitude.toString();

    //laitudeとlongitudeを返す
    return [latitude, longitude];
  }

  //localhost:3000のサーバーにhttp通信で現在地をPOSTする関数
  Future<String> http_post() async {
    //200--success
    var gps = await _getMYgps();
    var response = await http.post(Uri.parse(
        //localhost:3000/gps?lat=latitude&lon=longitude&purpose=purpose
        "http://localhost:3000/gps?lat=${gps[0]}&lon=${gps[1]}&purpose=$purpose"));
    //「緯度：latitude,経度：longitude」をprintする
    print("緯度：${gps[0]}、経度：${gps[1]}");
    return (response.body);
  }

  //初期化
  @override
  void initState() {
    super.initState();
    future = Future(() async {
      return await http_post();
    });
  }

  //画面の描画
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //検索結果表示画面のタイトル
        title: const Text('GPS情報'),
      ),
      body: Center(
        child: Center(
          child: Column(
            //中央配置
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
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
            ],
          ),
        ),
      ),
    );
  }
}
