// swift-tools-version:5.3
import PackageDescription
let package = Package(
    name: "tic-tac-toe",
    products: [
        .executable(name: "tic-tac-toe", targets: ["tic-tac-toe"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", .exact("0.8.0")),
        .package(url: "https://github.com/johngarrett/HyperSwift", .branch("master"))
        
    ],
    targets: [
        .target(
            name: "tic-tac-toe",
            dependencies: [.product(name: "JavaScriptKit", package: "JavaScriptKit"), "HyperSwift"]
        )
    ]
)
