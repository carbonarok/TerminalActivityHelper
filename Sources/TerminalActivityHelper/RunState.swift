
import Foundation

enum RunStatus: String {
    case running
    case success
    case failure
}

struct RunState: Identifiable {
    let id: String
    let title: String
    let command: String
    var status: RunStatus
    var exitCode: Int?
    let startedAt: Date
    var finishedAt: Date?
}

