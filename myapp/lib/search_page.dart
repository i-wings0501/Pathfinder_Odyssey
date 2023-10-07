import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/detail_route.dart';
//追加
import 'package:myapp/location_client.dart';
// import 'package:latlong2/latlong.dart';

//検索結果表示画面
class SearchPage extends StatefulWidget {
  //前の画面から受け取った値を格納する変数:purpose
  SearchPage(this.purpose);
  final String purpose;

  @override
  //SearchPageTodoを返す
  //SearchPageTodoにpurposeを渡す
  State<SearchPage> createState() => SearchPageTodo(purpose);
}

//検索結果表示画面のwidget
class SearchPageTodo extends State<SearchPage> {
  //SearchPageから受け取った値を格納する変数:purpose
  SearchPageTodo(this.purpose);
  final String purpose;

  late Future<String> future;

  late VoidCallback onPressed;

  //追加
  final _locationClient = LocationClient();
  // final _points = <LatLng>[];
  // LatLng? _currPosition;
  // bool _isServiceRunning = false;

  // 現在地を取得する関数
  _getMYgps() async {
    await _locationClient.init();
    //現在地を取得する
    // final position = await _locationClient.locationStream.first;
    debugPrint("getLocation 1");
    final position = await _locationClient.getLocation();
    debugPrint("getLocation 2");
    //現在地の緯度を取得する
    final latitude = position.latitude.toString();
    //現在地の経度を取得する
    final longitude = position.longitude.toString();

    //laitudeとlongitudeを返す
    return [latitude, longitude];
  }

  //https://stackoverflow.com/questions/76427712/the-class-list-doesnt-have-an-unnamed-constructor
  List _PlaceInfos = [];

  //localhost:3000のサーバーにhttp通信で現在地から周辺の建物情報をGETする関数
  //https://dev.classmethod.jp/articles/flutter-rest-api/
  Future<void> http_get_PlaceInfo() async {
    //現在地を取得する
    var gps = await _getMYgps();
    //http通信で現在地から周辺の建物情報をGETする
    var response = await http.get(Uri.parse(
        //localhost:3000/gps?lat=latitude&lon=longitude&purpose=purpose
        "http://localhost:3000/gps?lat=${gps[0]}&lon=${gps[1]}&purpose=$purpose"));

    //200--success
    //http通信の結果をJson型に変換する
    if (response.statusCode == 200) {
      var InfosJson = jsonDecode(response.body);
      setState(() {
        _PlaceInfos = InfosJson;
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  //画面が作成された時に呼び出される関数
  @override
  void initState() {
    http_get_PlaceInfo();
    super.initState();
  }

  //画面の描画
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //検索結果表示画面のタイトル
          title: const Text('GPS情報'),
        ),

        //検索結果表示画面のbody
        body: ListView.builder(
          itemCount: _PlaceInfos.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  bottom: 150,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(_PlaceInfos[index]['name']),
                      subtitle: Text(_PlaceInfos[index]['place_id']),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          //新しい画面に遷移;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              //遷移先の画面に入力されたテキストを渡す
                              builder: (context) =>
                                  RoutePage(_PlaceInfos[index]['place_id']),
                            ),
                          );
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(builder: (context) {
                          //     return const SearchPage();
                          //   }),
                          // );
                        },
                        child: const Text('経路を検索')),
                  ],
                ),
              ),
            );
          },
        )
        // body: Center(
        //   child: Center(
        //     child: Column(
        //       //中央配置
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         FutureBuilder(
        //           future: future,
        //           builder: (context, AsyncSnapshot<String> snapshot) {
        //             if (snapshot.hasData) {
        //               return Text(snapshot.data![0]);
        //             } else if (snapshot.hasError) {
        //               return Text("${snapshot.error}");
        //             }
        //             return const CircularProgressIndicator();
        //           },
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
