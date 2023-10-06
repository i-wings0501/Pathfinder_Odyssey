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
    GMSServices.provideAPIKey("AIzaSyD-LkWuUiOK8tHL0b48IxmYFDGy0Y0p8o8")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
