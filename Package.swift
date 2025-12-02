// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "TerminalActivityHelper",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "TerminalActivityHelper",
            targets: ["TerminalActivityHelper"]
        )
    ],
    targets: [
        .executableTarget(
            name: "TerminalActivityHelper",
            dependencies: [],
            path: "Sources/TerminalActivityHelper"
        )
    ]
)

