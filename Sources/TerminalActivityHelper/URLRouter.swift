import Foundation

@MainActor
final class URLRouter {
    static let shared = URLRouter()
    private init() {}

    func handle(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let host = components.host else { return }

        func q(_ name: String) -> String? {
            components.queryItems?.first(where: { $0.name == name })?.value
        }

        switch host {
        case "start":
            guard let runID = q("run_id"),
                  let title = q("title"),
                  let cmd = q("cmd") else { return }

            RunManager.shared.startRun(
                runID: runID,
                title: title,
                command: cmd
            )

        case "end":
            guard let runID = q("run_id"),
                  let status = q("status"),
                  let exitStr = q("exit"),
                  let exitCode = Int(exitStr) else { return }

            let success = (status == "success")
            RunManager.shared.finishRun(
                runID: runID,
                success: success,
                exitCode: exitCode
            )

        default:
            break
        }
    }
}

