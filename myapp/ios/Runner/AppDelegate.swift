import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Google Maps
    GMSServices.provideAPIKey("AIzaSyCk1KefLQjDUy1sOaEEka9W0Gm_ZyGIBFY")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
