// Copyright 2021 Google LLC. All Rights Reserved.
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

public protocol RefreshExchangeInfo {
  var accessTokenURL: String { get }
  var clientID: String { get }
  var clientSecret: String { get }
}

public class Refresh {
    
  let token: String
    
  public convenience init?(token data: Data) {
    if let token = try? JSONDecoder().decode(Token.self, from: data) {
      self.init(token: token)
    } else {
      return nil
    }
  }
  
  init?(token: Token) {
    if let rt = token.RefreshToken {
      self.token = rt
      return
    }
    return nil
  }
  
  public func exchange(info: RefreshExchangeInfo) throws -> Token {
    let sem = DispatchSemaphore(value: 0)
    let parameters = [
      "client_id": info.clientID,
      "client_secret": info.clientSecret,
      "grant_type": "refresh_token",
      "refresh_token": self.token,
    ]
    let token = info.clientID + ":" + info.clientSecret
    // some providers require the client id and secret in the authorization header
    let authorization = "Basic " + String(data: token.data(using: .utf8)!.base64EncodedData(), encoding: .utf8)!
    var responseData: Data?
    var contentType: String?
    Connection.performRequest(
      method: "POST",
      urlString: info.accessTokenURL,
      parameters: parameters,
      body: nil,
      authorization: authorization
    ) { data, response, _ in
      if let response = response as? HTTPURLResponse {
        for (k, v) in response.allHeaderFields {
          // Explicitly-lowercasing seems like it should be unnecessary,
          // but some services returned "Content-Type" and others sent "content-type".
          if (k as! String).lowercased() == "content-type" {
            contentType = v as? String
          }
        }
      }
      responseData = data
      sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    if let contentType = contentType, contentType.contains("application/json") {
      let decoder = JSONDecoder()
      let token = try! decoder.decode(Token.self, from: responseData!)
      return token
    } else { // assume "application/x-www-form-urlencoded"
      guard let responseData = responseData else {
        throw AuthError.unknownError
      }
      guard let queryParameters = String(data: responseData, encoding: .utf8) else {
        throw AuthError.unknownError
      }
      guard let urlComponents = URLComponents(string: "http://example.com?" + queryParameters) else {
        throw AuthError.unknownError
      }
      var token = Token(urlComponents: urlComponents)
      if token.RefreshToken == nil {
        // Google refresh tokens are persistent
        token.RefreshToken = self.token
      }
      return token
    }
  }
}
