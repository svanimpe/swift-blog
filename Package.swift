// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "swift-blog",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.9.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.7.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", from: "1.11.0"),
        .package(url: "https://github.com/IBM-Swift/Swift-cfenv.git", from: "6.0.0")
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
