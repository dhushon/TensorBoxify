// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TensorBoxify",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "TensorBoxify",
            targets: ["TensorBoxify"]),
        .executable(
            name: "TensorBoxifyUI",
            targets: ["TensorBoxifyUI"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0",
    .package(url: "https://github.com/httpswift/swifter.git", .branch("stable")),
    .package(url: "https://github.com/dhushon/FilesProvider.git", .branch("master"))

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "TensorBoxify",
            dependencies: []),
        .target(
            name: "TensorBoxifyUI",
            dependencies: ["FilesProvider","TensorBoxify"]),
        .testTarget(
            name: "TensorBoxifyTests",
            dependencies: ["TensorBoxify","Swifter"]),
        .testTarget(
            name: "TensorBoxifyUITests",
            dependencies: ["TensorBoxifyUI"])
    ]
)
