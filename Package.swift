// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SwiftyMarisa",
    products: [
        .library(
            name: "SwiftyMarisa",
            targets: ["SwiftyMarisa"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftyMarisa",
            dependencies: ["CMarisaWrapper"]
        ),
        .target(
            name: "CMarisaWrapper",
            dependencies: ["marisa-trie"]
        ),
        .target(
            name: "marisa-trie",
            sources: ["marisa"],
            publicHeadersPath: "include",
            cxxSettings: [.headerSearchPath(".")]
        ),
        .testTarget(
            name: "SwiftyMarisaTests",
            dependencies: ["SwiftyMarisa"]
        ),
    ]
)
