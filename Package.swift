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
            dependencies: ["marisa"],
            cxxSettings: [.headerSearchPath("../marisa/lib")] // use cpp headers from the fake marisa lib
        ),
        //we don't expose any cpp haders here
        .target(
            name: "marisa",
            dependencies: [],
            sources: ["lib/marisa"]
        ),
        .testTarget(
            name: "SwiftyMarisaTests",
            dependencies: ["SwiftyMarisa"]
        ),
    ]
)
