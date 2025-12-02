import Foundation

@MainActor
final class RunManager {
    static let shared = RunManager()
    private init() {}

    private(set) var runs: [String: RunState] = [:]  // runID -> RunState

    func startRun(runID: String, title: String, command: String) {
        let state = RunState(
            id: runID,
            title: title,
            command: command,
            status: .running,
            exitCode: nil,
            startedAt: Date(),
            finishedAt: nil
        )
        runs[runID] = state
        StatusBarController.shared.update(with: Array(runs.values))
    }

    func finishRun(runID: String, success: Bool, exitCode: Int) {
        guard var state = runs[runID] else { return }

        state.status = success ? .success : .failure
        state.exitCode = exitCode
        state.finishedAt = Date()
        runs[runID] = state

        StatusBarController.shared.update(with: Array(runs.values))
        StatusBarController.shared.showNotification(title: state.title, body: state.command)
    }
}
