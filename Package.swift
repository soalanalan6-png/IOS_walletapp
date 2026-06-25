// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WalletApp",
    platforms: [
        .iOS(.v17)
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "WalletApp",
            dependencies: [],
            path: "Sources/WalletApp"
        )
    ]
)
