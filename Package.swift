// swift-tools-version:5.3
import PackageDescription
let package = Package(
    name: "tic-tac-toe",
    products: [
        .executable(name: "tic-tac-toe", targets: ["tic-tac-toe"])
    ],
    dependencies: [
        .package(name: "JavaScriptKit", url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.8.0")
    ],
    targets: [
        .target(
            name: "tic-tac-toe",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit")
            ]),
        .testTarget(
            name: "tic-tac-toeTests",
            dependencies: ["tic-tac-toe"]),
    ]
)