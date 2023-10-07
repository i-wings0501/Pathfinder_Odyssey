import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationClient {
  final Location _location = Location();

  Stream<LatLng> get locationStream => _location.onLocationChanged
      .map((event) => LatLng(event.latitude!, event.longitude!));

  Future<void> init() async {
    debugPrint("pre serviceEnabled");
    final serviceEnabled = await _location.serviceEnabled();
    debugPrint("post serviceEnabled");
    if (!serviceEnabled) {
      debugPrint("pre requestService");
      await _location.requestService();
      debugPrint("pre requestService");
    }
    debugPrint("pre hasPermission");
    var permissionStatus = await _location.hasPermission();
    debugPrint("post hasPermission");
    if (permissionStatus == PermissionStatus.denied) {
      debugPrint("pre requestPermission");
      permissionStatus = await _location.requestPermission();
      debugPrint("post requestPermission");
    }
    if (permissionStatus == PermissionStatus.granted) {
      debugPrint("pre enableBackgroundMode");
      await _location.enableBackgroundMode();
      debugPrint("post enableBackgroundMode");
      await _location.changeNotificationOptions(
        title: 'Geolocation',
        subtitle: 'Geolocation detection',
      );
      debugPrint("post changeNotificationOptions");
    }
  }

  Future<LocationData> getLocation() {
    return _location.getLocation();
  }

  Future<bool> isServiceEnabled() async {
    return _location.serviceEnabled();
  }
}
