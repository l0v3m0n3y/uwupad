// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "uwupad",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .library(name: "uwupad", targets: ["uwupad"]),
    ],
    targets: [
        .target(
            name: "uwupad",
            path: "src"
        ),
    ]
)
