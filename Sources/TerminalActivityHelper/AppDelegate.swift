import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the status bar item
        _ = StatusBarController.shared
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        for url in urls {
            URLRouter.shared.handle(url)
        }
    }
}

