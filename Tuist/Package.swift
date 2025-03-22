// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        productTypes: ["Alamofire": .framework, "RxSwift": .framework]
        )
#endif

let package = Package(
    name: "YongJi",
    dependencies: [
        // Add your own dependencies here:
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.9.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.8.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.4.0")
    ]
)
