// swift-tools-version:5.1

import PackageDescription

let package = Package(
	name: "AdComData",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15),
	],
	products: [
		.library(
			name: "AdComData",
			targets: ["AdComData"]
		),
	],
	dependencies: [
		.package(path: "flatbuffers/swift"),
		.package(url: "https://github.com/juliand665/HandyOperators.git", .branch("master")),
	],
	targets: [
		.target(
			name: "AdComData",
			dependencies: ["FlatBuffers", "HandyOperators"]
		),
		.testTarget(
			name: "AdComDataTests",
			dependencies: ["AdComData"]
		),
	]
)
