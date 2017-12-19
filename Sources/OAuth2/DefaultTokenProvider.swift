// Copyright 2017 Google Inc. All Rights Reserved.
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

// WARNING: This is an INCOMPLETE implementation of Application Default Credentials.
// It supports service accounts through the GOOGLE_APPLICATION_CREDENTIALS environment variable.
// No other authorization methods are supported yet.

public class DefaultTokenProvider : TokenProvider {
  public var token: Token?
  private var serviceAccountTokenProvider : ServiceAccountTokenProvider

  public init?() {
    guard let credentials = ProcessInfo.processInfo.environment["GOOGLE_APPLICATION_CREDENTIALS"] else {
      return nil
    }
    let credentialsURL = URL(fileURLWithPath:credentials)
    guard let provider = ServiceAccountTokenProvider(credentialsURL:credentialsURL) else {
      return nil
    }
    serviceAccountTokenProvider = provider
  }

  public func withToken(_ callback:@escaping (Token?, Error?) -> Void) throws {
    try serviceAccountTokenProvider.withToken() {(token, error) in
      self.token = token
      callback(token, error)
    }
  }
}

