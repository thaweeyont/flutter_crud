import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      UNUserNotificationCenter.current().requestAuthorization(options: [
                 .badge, .sound, .alert
               ]) { granted, _ in
                 guard granted else { return }

                 DispatchQueue.main.async {
                   application.registerForRemoteNotifications()
                 }
               }
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
 let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
   print(token)
}

