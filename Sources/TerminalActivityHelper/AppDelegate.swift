
import AppKit
import UserNotifications

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 1) Ask for notification permission
        requestNotificationPermission()

        // 2) Create the status bar item
        _ = StatusBarController.shared
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error = error {
                print("Error requesting permission: \(error)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        for url in urls {
            URLRouter.shared.handle(url)
        }
    }
}

