import UIKit
import Flutter
import GoogleMaps
import flutter_config

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Add my Google Maps API key
    GMSServices.provideAPIKey(FlutterConfigPlugin.env(for: "API_key"))
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
