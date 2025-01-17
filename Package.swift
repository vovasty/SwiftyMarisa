// swift-tools-version:5.10

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
            dependencies: ["marisa-trie"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
        .target(
            name: "marisa-trie",
            sources: ["marisa"],
            cxxSettings: [.headerSearchPath(".")]
        ),
        .testTarget(
            name: "SwiftyMarisaTests",
            dependencies: ["SwiftyMarisa"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
    ]
)
