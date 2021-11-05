[![Swift Actions Status](https://github.com/googleapis/google-auth-library-swift/workflows/Swift/badge.svg)](https://github.com/googleapis/google-auth-library-swift/actions)

# Auth Library for Swift

This project contains Swift packages that can be used to write command-line
tools and cloud services that use OAuth to authenticate and authorize access
to remote services.

Currently these packages support OAuth1 and OAuth2.
They are designed to work on macOS systems and on Linux systems that are
running in the [Google Cloud](https://cloud.google.com).

* On macOS systems, OAuth tokens can be obtained using the locally-installed
browser and a local web server that is automatically run in the
command-line client. 

* On Linux systems, OAuth tokens can be obtained automatically from the
[Google Cloud Metadata Service](https://cloud.google.com/compute/docs/storing-retrieving-metadata).

* On both Linux and macOS systems, OAuth tokens can be obtained automatically for
[Google Cloud Service Accounts](https://cloud.google.com/iam/docs/understanding-service-accounts).

## Usage and Examples

[Sources/Examples](Sources/Examples) 
contains examples that illustrate OAuth1 and OAuth2 signin for
various services. Each requires valid application credentials to run.
See the various service providers for details.

The BrowserTokenProvider classes use a local web server to implement
"three-legged OAuth" signin in which users grant permission in a browser
that a provider's server redirects to the client server with a code.
These providers look for OAuth configuration information in "credentials"
YAML files that are expected to be in `$HOME/.credentials`. Sample credentials
files are in [credentials](credentials)
and include client IDs, client secrets, and OAuth service URLs.
When OAuth services require registered callback URLs, these should be
set to `http://localhost:8080/SERVICE/callback` where `SERVICE` is 
specified in the corresponding credentials YAML file. The temporary 
web server runs locally on port 8080.

## Credits

- The local web server is built using [swift-nio/http](https://github.com/apple/swift-nio).
- HMAC and SHA1 hashing is performed using [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift).
- RSA signing of service account JWT tokens uses [BigInt](https://github.com/attaswift/BigInt).

## Disclaimer

This is work in progress toward great server-side Swift software. Please take care
when using this in production projects: always refer to a tagged version and 
be aware that interfaces may change in future releases.

## Contributing

We'd love to collaborate on this. See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Copyright

Copyright 2019, Google LLC.

## License

Released under the Apache 2.0 license.
