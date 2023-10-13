// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HideShowPasswordTextField",
    platforms: [.iOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "HideShowPasswordTextField",
            targets: ["HideShowPasswordTextField"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "HideShowPasswordTextField",
            resources: [
                .process("ic_eye_open.png"),
                .process("ic_eye_open@2x.png"),
                .process("ic_eye_open@3x.png"),
                .process("ic_eye_closed.png"),
                .process("ic_eye_closed@2x.png"),
                .process("ic_eye_closed@3x.png"),
                .process("ic_password_checkmark.png"),
                .process("ic_password_checkmark@2x.png"),
                .process("ic_password_checkmark@3x.png")
            ])
    ]
)
