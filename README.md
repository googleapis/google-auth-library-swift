# Auth Library for Swift

This project contains Swift packages that can be used to write command-line
tools and cloud services that use OAuth to authenticate and authorize access
to remote services.

Currently these packages support OAuth1 and OAuth2.
They are designed to work on OS X systems and on Linux systems that are
running in the [Google Cloud](https://cloud.google.com).
On OS X systems, OAuth tokens can be obtained using the locally-installed
browser and a local web server that is automatically run in the
command-line client. 
On Linux systems, OAuth tokens can be obtained from the
[Google Cloud Metadata Service](https://cloud.google.com/compute/docs/storing-retrieving-metadata).

## Usage and Examples

[Sources/Examples](Sources/Examples) 
contains examples that illustrate OAuth1 and OAuth2 signin for
various services. Each requires valid application credentials to run.
See the various service providers for details.

Services look for OAuth configuration information in "credentials" YAML files
that are expected to be in $HOME/.credentials. Sample credentials
files are in [credentials](credentials)
and include client IDs, client secrets, and OAuth service URLs.

When OAuth services require registered callback URLs, these should be
set to `http://localhost:8080/SERVICE/callback` where `SERVICE` is 
specified in the corresponding credentials YAML file. The temporary 
web server runs locally on port 8080.

## Credits

- The local web server is built using the [Kitura](https://github.com/IBM-Swift/Kitura) web framework.
- HMAC hashing is performed using [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift).

## Disclaimer

This is work in progress toward great server-side Swift software. Please take care
when using this in production projects: always refer to a tagged version and 
be aware that interfaces may change in future releases.

## Contributing

We'd love to collaborate on this. See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Copyright

Copyright 2017, Google Inc.

## License

Released under the Apache 2.0 license.
