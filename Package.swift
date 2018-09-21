// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "swift-blog",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", .upToNextMinor(from: "1.7.0")),
        .package(url: "https://github.com/IBM-Swift/Kitura.git", .upToNextMinor(from: "2.5.0")),
        .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", .upToNextMinor(from: "1.10.0")),
        .package(url: "https://github.com/IBM-Swift/Swift-cfenv.git", .upToNextMinor(from: "6.0.0"))
    ],
    targets: [
        .target(name: "swift-blog", dependencies: [
            "HeliumLogger",
            "Kitura",
            "KituraStencil",
            "CloudFoundryEnv"
        ])
    ]
)
