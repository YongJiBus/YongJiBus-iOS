import ProjectDescription

let project = Project(
    name: "YongJiBus",
    organizationName: "yongjibus.org.",
    settings: Settings.settings(base: ["OTHER_LDFLAGS":["-all_load -Objc"]]),
    targets: [
        .target(
            name: "YongJiBus",
            destinations: .iOS,
            product: .app,
            bundleId: "Bryan.YongJiBus",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .file(path: "YongJi/Support/Info.plist"),
            sources: ["YongJi/Sources/**" ],
            resources: ["YongJi/Resources/**",
                        "YongJi/Sources/Data/*.json",
                        "Sources/GoogleService-Info.plist"],
            entitlements: "YongJiBus.entitlements",
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "RxSwift"),
                .external(name: "FirebaseMessaging"),
                .external(name: "FirebaseAnalytics")
            ]
        ),
        .target(
             name: "YongJiBusTests",
             destinations: .iOS,
             product: .unitTests,
             bundleId: "YongJiBus.tests",
             deploymentTargets: .iOS("17.0"),
             infoPlist: .default,
             sources: ["YongJi/Tests/**"],
             dependencies: [
                 .target(name: "YongJiBus") // 메인 앱 타겟 의존성 추가
             ]
         )
    ]
)
