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
import Dispatch

struct OAuth2RefreshCredentials : Codable {
  let clientID : String
  let clientSecret : String
  let refreshToken : String
  let tokenType : String
  enum CodingKeys: String, CodingKey {
    case clientID = "client_id"
    case clientSecret = "client_secret"
    case refreshToken = "refresh_token"
    case tokenType = "type"
  }
}

let accessTokenPath = "https://accounts.google.com/o/oauth2/token"

public class GoogleRefreshTokenProvider: TokenProvider {
  private var credentials : OAuth2RefreshCredentials
  public var token: Token?

  public init?(credentialsURL: URL) {
    guard let credentialsData = try? Data(contentsOf:credentialsURL) else {
      return nil
    }
    let decoder = JSONDecoder()
    guard let credentials = try? decoder.decode(OAuth2RefreshCredentials.self,
                                                from: credentialsData)
      else {
        return nil
    }
    self.credentials = credentials
    do {
      self.token = try exchange()
      if self.token == nil {
        return nil
      }
    } catch {
      return nil
    }
  }

  private func exchange() throws -> Token? {
    let parameters = [
      "client_id": credentials.clientID,
      "client_secret": credentials.clientSecret,
      "grant_type": "refresh_token",
      "refresh_token": credentials.refreshToken]
    var responseData: Data?
    let sem = DispatchSemaphore(value: 0)
    Connection.performRequest(
      method: "POST",
      urlString: accessTokenPath,
      parameters: parameters,
      body: nil,
      authorization: "") { data, response, _ in
        responseData = data
        sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    // assume content type is "application/json"
    let decoder = JSONDecoder()
    let token = try? decoder.decode(Token.self, from: responseData!)
    return token
  }

  public func withToken(_ callback: @escaping (Token?, Error?) -> Void) throws {
    callback(token, nil)
  }
}
