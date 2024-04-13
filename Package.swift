// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "HTTIES",
	platforms: [
		.macOS(.v12), // macOS minimum version set to 12.0
		.iOS(.v15),   // iOS minimum version set to 15.0
		.watchOS(.v8),// watchOS minimum version set to 8.0
		.tvOS(.v15)   // tvOS minimum version set to 15.0
	],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "HTTIES",
			targets: ["HTTIES"]),
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "HTTIES"),
		.testTarget(
			name: "HTTIESTests",
			dependencies: ["HTTIES"]),
	]
)
