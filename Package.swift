// swift-tools-version:4.0

//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import PackageDescription

let package = Package(
  name: "Auth",
  products: [
    .library(name: "OAuth1", targets: ["OAuth1"]),
    .library(name: "OAuth2", targets: ["OAuth2"]),
  ],
  dependencies: [
    .package(url: "https://github.com/swift-server/http", from: "0.1.0"),
    .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "0.8.0"),
    .package(url: "https://github.com/attaswift/BigInt", from: "3.0.0"),
    .package(url: "https://github.com/timburks/SwiftyBase64", from: "1.2.0"),
  ],
  targets: [
    .target(name: "OAuth1",
            dependencies: ["CryptoSwift", "HTTP"]),
    .target(name: "OAuth2",
            dependencies: ["CryptoSwift", "HTTP", "BigInt", "SwiftyBase64"]),
    .target(name: "TokenSource", dependencies: ["OAuth2"], path: "Sources/Examples/TokenSource"),
    .target(name: "Google",      dependencies: ["OAuth2"], path: "Sources/Examples/Google"),
    .target(name: "GitHub",      dependencies: ["OAuth2"], path: "Sources/Examples/GitHub"),
    .target(name: "Meetup",      dependencies: ["OAuth2"], path: "Sources/Examples/Meetup"),
    .target(name: "Spotify",     dependencies: ["OAuth2"], path: "Sources/Examples/Spotify"),
    .target(name: "Twitter",     dependencies: ["OAuth1"], path: "Sources/Examples/Twitter"),
  ]
)
