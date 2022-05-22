#
# Be sure to run `pod lib lint AuthLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name = "AuthLibrary"
  s.version = "0.5.0"
  s.summary = "Auth client library for Swift command-line tools, cloud services, and apps."
  s.swift_version = "5.0"
  s.ios.deployment_target = "10.0"

  s.description = <<-DESC
Swift packages that can be used to write command-line tools and cloud services that use OAuth to authenticate and authorize access to remote services.

Currently these packages support OAuth1 and OAuth2. They are designed to work on OS X systems and on Linux systems that are running in the Google Cloud.

The CocoaPods distribution supports iOS-based authentication using Google Cloud Service Accounts (only).
                       DESC

  s.homepage = "https://github.com/google/auth-library-swift"
  s.license = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author = "Google"
  s.source = { :git => "https://github.com/google/auth-library-swift.git", :tag => s.version.to_s }

  s.source_files =
    "Sources/OAuth2/Code.swift",
    "Sources/OAuth2/Connection.swift",
    "Sources/OAuth2/ServiceAccountTokenProvider/ASN1.swift",
    "Sources/OAuth2/ServiceAccountTokenProvider/JWT.swift",
    "Sources/OAuth2/ServiceAccountTokenProvider/RSA.swift",
    "Sources/OAuth2/ServiceAccountTokenProvider/ServiceAccountTokenProvider.swift",
    "Sources/OAuth2/Token.swift",
    "Sources/OAuth2/TokenProvider.swift",
    "Sources/OAuth2/FCMTokenProvider/FCMTokenProvider.swift"

  s.static_framework = true
  s.dependency "CryptoSwift", "~> 1.0.0"
  s.dependency "BigInt", "~> 3.1.0"
  s.dependency "SwiftyBase64", "~> 1.1.1"
  s.dependency "SwiftNIO", "~> 2.32.0"
  s.dependency "Firebase/Core"
  s.dependency "Firebase/Functions"
  s.dependency "Firebase/Auth"
  s.dependency "Firebase/Firestore"
end
