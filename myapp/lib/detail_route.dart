import 'package:flutter/material.dart ';
import 'package:geolocator/geolocator.dart';

//経路情報を出力する画面
class RoutePage extends StatefulWidget {
  //前の画面から受け取った値を格納する変数:purpose
  RoutePage(this.purpose);
  final void purpose;

  @override
  //RoutePageTodoを返す
  //RoutePageTodoにpurposeを渡す
  State<RoutePage> createState() => RoutePageTodo(purpose);
}

//経路情報を出力する画面のwidget
class RoutePageTodo extends State<RoutePage> {
  RoutePageTodo(this.purpose);
  final void purpose;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //検索結果表示画面のタイトル
          title: const Text('GPS情報'),
        ),
        body: Container(
          child: //void型のpurposeを表示する
              Text("経路情報の出力"),
        ));
  }
}
