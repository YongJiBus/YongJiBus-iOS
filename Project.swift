import ProjectDescription

let project = Project(
    name: "YongJiBus",
    targets: [
        .target(
            name: "YongJiBus",
            destinations: .iOS,
            product: .app,
            bundleId: "Bryan.YongJiBUs",
            infoPlist: .file(path: "Info.plist"),
            sources: ["YongJi/Sources/**"],
            resources: ["YongJi/Resources/**"],
            dependencies: [
                .external(name: "Alamofire")
            ]
        )
    ]
)
