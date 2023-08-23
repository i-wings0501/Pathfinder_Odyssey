import 'package:flutter/material.dart ';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

//検索結果表示画面
class SerchPage extends StatefulWidget {
  //前の画面から受け取った値を格納する変数:porpose
  SerchPage(this.porpose);
  final String porpose;

  @override
  //SerchPageTodoを返す
  //SerchPageTodoにporposeを渡す
  State<SerchPage> createState() => SerchPageTodo(porpose);
}

//検索結果表示画面のwidget
class SerchPageTodo extends State<SerchPage> {
  //SerchPageから受け取った値を格納する変数:porpose
  SerchPageTodo(this.porpose);
  final String porpose;

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

    //laitudeとlongitudeを返す
    return [latitude, longitude];
  }

  Future<String> http_post() async {
    //200--success
    var gps = await _getMYgps();
    var response = await http.post(Uri.parse(
        "http://localhost:3000/gps?lat=${gps[0]}&lon=${gps[1]}&porpose=$porpose"));
    //「緯度：latitude,経度：longitude」をprintする
    print("緯度：${gps[0]}、経度：${gps[1]}");
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(porpose),
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
