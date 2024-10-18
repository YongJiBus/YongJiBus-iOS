import ProjectDescription

let project = Project(
    name: "YongJiBus",
    organizationName: "yongjibus.org.",
    targets: [
        .target(
            name: "YongJiBus",
            destinations: .iOS,
            product: .app,
            bundleId: "YongJiBus.app",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .file(path: "YongJi/Support/Info.plist"),
            sources: ["YongJi/Sources/**" ],
            resources: ["YongJi/Resources/**","YongJi/Sources/Data/*.json"],
            dependencies: [
                .external(name: "Alamofire")
            ]
        )
    ]
)
