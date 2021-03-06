// swift-tools-version:4.0
//
//  Package.swift
//  CoreTensor
//
//  Copyright 2016-2017 The DLVM Team.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import PackageDescription

let package = Package(
    name: "CoreTensor",
    products: [
        .library(name: "CoreTensor", type: .static,
                 targets: ["CoreTensor"]),
        .library(name: "RankedTensor", type: .static,
                 targets: ["RankedTensor"]),
    ],
    targets: [
        .target(name: "CoreTensor"),
        .target(name: "RankedTensor", dependencies: ["CoreTensor"]),
        .testTarget(name: "CoreTensorTests", dependencies: ["CoreTensor"]),
        .testTarget(name: "RankedTensorTests", dependencies: ["RankedTensor"])
    ],
    swiftLanguageVersions: [4]
)
