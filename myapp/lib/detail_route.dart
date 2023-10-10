import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:myapp/location_client.dart';

//経路情報を出力する画面
class RoutePage extends StatefulWidget {
  //前の画面から受け取った値を格納する変数:purpose
  RoutePage(this.purpose);
  final String purpose;

  @override
  //RoutePageTodoを返す
  //RoutePageTodoにpurposeを渡す
  State<RoutePage> createState() => RoutePageTodo(purpose);
}

//経路情報を出力する画面のwidget
class RoutePageTodo extends State<RoutePage> {
  RoutePageTodo(this.place_id);
  final Completer<GoogleMapController> _controller = Completer();

  late Future<String> future;

  final String place_id;
  final _locationClient = LocationClient();

  //必要
  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  // Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];
  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  //現在地を取得する関数
  List<double> _MYgps = [];
  _getMYgps() async {
    //現在地を取得する
    // final position = await _locationClient.locationStream.first;
    final position = await _locationClient.getLocation();
    //現在地の緯度を取得する
    final latitude = position.latitude;
    //現在地の経度を取得する
    final longitude = position.longitude;

    if (latitude != null && longitude != null) {
      setState(() {
        _MYgps = [latitude, longitude];
      });
      await http_get_PlaceRoute(latitude, longitude);
    }
  }

  List _PlaceRoute = [];
  Future<void> http_get_PlaceRoute(double lat, double lng) async {
    //http通信で現在地から周辺の建物情報をGETする
    var response = await http.get(Uri.parse(
        //localhost:3000/gps?lat=latitude&lon=longitude&purpose=purpose
        "http://localhost:3000/route?lat=${lat.toString()}&lon=${lng.toString()}&place_id=$place_id"));

    //200--success
    //http通信の結果をJson型に変換する
    if (response.statusCode == 200) {
      var RouteJson = jsonDecode(response.body);
      setState(() {
        _PlaceRoute = RouteJson;
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  // 画面が作成された時に呼び出される関数
  @override
  void initState() {
    super.initState();
    _getMYgps();
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent,
      ),
    );
  }

  Polyline _createPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;

    // デバッグ
    // debugPrint(points.toString());
    return Polyline(
      polylineId: PolylineId(polylineIdVal),
      width: 5,
      color: Colors.blue,
      points: points
          .map(
            (point) => LatLng(point.latitude, point.longitude),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    //現在地を取得するまでの間は、ロード画面を表示する
    if (_MYgps.isEmpty || _PlaceRoute.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            //検索結果表示画面のタイトル
            title: const Text('経路'),
          ),
          body: const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          ));
    }

    //現在地を取得する
    CameraPosition _firstNowLocation = CameraPosition(
      target: LatLng(_MYgps[0], _MYgps[1]),
      zoom: 16.4746,
    );

    Marker _destinationLocationMaker = Marker(
      markerId: const MarkerId('_firstNowLocation'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(_PlaceRoute[0]['legs']['end_location']['lat'],
          _PlaceRoute[0]['legs']['end_location']['lng']),
    );

    CameraPosition _NowLocation = CameraPosition(
      target: LatLng(_MYgps[0], _MYgps[1]),
      zoom: 20,
    );

    var polyline_decoded = PolylinePoints()
        .decodePolyline(_PlaceRoute[0]['overview_polyline']['points']);
    var polyline = _createPolyline(polyline_decoded);

    return Scaffold(
      appBar: AppBar(
        //検索結果表示画面のタイトル
        title: const Text('経路'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              //マップタイプを指定
              mapType: MapType.normal,
              //マーカーを指定
              markers: {
                _destinationLocationMaker,
              },
              // polygons: _polygons,
              polylines: {
                polyline,
              },
              //初期表示位置を指定
              initialCameraPosition: _firstNowLocation,
              //
              myLocationEnabled: true,
              //現在位置に移動するボタンを表示
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      //ボタンを押したら現在地に移動するボタンを配置する
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final GoogleMapController controller = await _controller.future;
          controller
              .animateCamera(CameraUpdate.newCameraPosition(_NowLocation));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.location_on),
      ),
    );

    // _PlaceRoute
    // _PlaceRoute[0]['legs']['start_location']['lat'],
    // _PlaceRoute[0]['legs']['start_location']['lng'],
    // _PlaceRoute[0]['bounds']['northeast'],
    // _PlaceRoute[0]['bounds']['southwest'],
  }
}
