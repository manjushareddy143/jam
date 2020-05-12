import UIKit
import Flutter
// import Firebase
import Firebase
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            registerForPushNotifications()
        } else {
            // Fallback on earlier versions
        }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    @available(iOS 10.0, *)
    func registerForPushNotifications() {
      UNUserNotificationCenter.current() // 1
        .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
          granted, error in
          print("Permission granted: \(granted)") // 3
      }
    }
    override func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      let tokenParts =
    deviceToken.map
     { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("Device Token: \(token)")
    }

    override func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
}
