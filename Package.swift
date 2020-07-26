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
    dependencies: [],
    targets: [
        .target(
            name: "SwiftyMarisa",
            dependencies: ["CMarisaWrapper"]
        ),
        .target(
            name: "CMarisaWrapper",
            dependencies: ["marisa-trie"]
        ),
        // we don't expose any cpp haders here
        .target(
            name: "marisa-trie",
            sources: ["lib/marisa"],
            publicHeadersPath:"include",
            cxxSettings: [.headerSearchPath("lib")]
        ),
        .testTarget(
            name: "SwiftyMarisaTests",
            dependencies: ["SwiftyMarisa"]
        ),
    ]
)
