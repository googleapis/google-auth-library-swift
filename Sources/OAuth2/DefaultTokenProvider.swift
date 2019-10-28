// Copyright 2019 Google LLC. All Rights Reserved.
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

import Foundation

// This class implements Google Application Default Credentials.
// https://developers.google.com/identity/protocols/application-default-credentials

public class DefaultTokenProvider : TokenProvider {
  public var token: Token?
  private var tokenProvider : TokenProvider
  
  public init?(scopes:[String]) {
    // if GOOGLE_APPLICATION_CREDENTIALS is set,
    // use it to get service account credentials.
    if let credentialsPath = ProcessInfo.processInfo.environment["GOOGLE_APPLICATION_CREDENTIALS"]  {
      let credentialsURL = URL(fileURLWithPath:credentialsPath)
      guard let provider = ServiceAccountTokenProvider(credentialsURL:credentialsURL, scopes:scopes) else {
        return nil
      }
      tokenProvider = provider
      return
    }
    // if $HOME/.config/gcloud/application_default_credentials.json exists,
    // use it to request an access token and warn the user about possible
    // problems.
    if let home = ProcessInfo.processInfo.environment["HOME"] {
      let credentialsPath = home + "/.config/gcloud/application_default_credentials.json"
      if FileManager.default.fileExists(atPath:credentialsPath) {
        let credentialsURL = URL(fileURLWithPath:credentialsPath)
        guard let provider = GoogleRefreshTokenProvider(credentialsURL:credentialsURL) else {
          return nil
        }
        tokenProvider = provider
        print("""
Your application has authenticated using end user credentials from Google
Cloud SDK. We recommend that most server applications use service accounts
instead. If your application continues to use end user credentials from Cloud
SDK, you might receive a "quota exceeded" or "API not enabled" error. For
more information about service accounts, see
https://cloud.google.com/docs/authentication/.
""")
        return
      }
    }
    // as a last resort, assume we are running on Google Compute Engine or Google App Engine
    // and try to get a token from the metadata service.
    guard let provider = GoogleCloudMetadataTokenProvider() else {
      return nil
    }
    tokenProvider = provider
  }
  
  public func withToken(_ callback:@escaping (Token?, Error?) -> Void) throws {
    try tokenProvider.withToken() {(token, error) in
      self.token = token
      callback(token, error)
    }
  }
}

