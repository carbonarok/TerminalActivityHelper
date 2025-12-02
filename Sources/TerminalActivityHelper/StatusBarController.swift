import AppKit
import UserNotifications

@MainActor
final class StatusBarController {
    static let shared = StatusBarController()

    private let statusItem: NSStatusItem

    private init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        setupInitialMenu()
    }

    private func setupInitialMenu() {
        if let button = statusItem.button {
            button.title = "⏱"
            button.toolTip = "TerminalActivityHelper"
        }

        let menu = NSMenu()
        menu.addItem(withTitle: "No active runs", action: nil, keyEquivalent: "")
        menu.addItem(.separator())
        let quitItem = NSMenuItem(
            title: "Quit TerminalActivityHelper",
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    func showNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil  // deliver immediately
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            }
        }
    }

    func update(with runs: [RunState]) {
        let menu = NSMenu()

        if runs.isEmpty {
            menu.addItem(withTitle: "No active runs", action: nil, keyEquivalent: "")
        } else {
            for run in runs.sorted(by: { $0.startedAt < $1.startedAt }) {
                let symbol: String
                switch run.status {
                case .running: symbol = "⏳"
                case .success: symbol = "✅"
                case .failure: symbol = "❌"
                }

                var title = "\(symbol) \(run.command)"
                if let code = run.exitCode, run.status != .running {
                    title += " (exit \(code))"
                }

                let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
                item.toolTip = "\(run.title) – started \(run.startedAt)"
                menu.addItem(item)
            }
        }

        menu.addItem(.separator())
        let quitItem = NSMenuItem(
            title: "Quit TerminalActivityHelper",
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
