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
import SwiftyJSON

public class Token {
  public var accessToken: String?
  public var tokenType: String?
  public var expiresIn: String?
  public var refreshToken: String?
  public var scope: String?

  public var creationTime: Date?

  public init(accessToken: String) {
    self.accessToken = accessToken
  }

  public init(urlComponents: URLComponents) {
    creationTime = Date()
    for queryItem in urlComponents.queryItems! {
      if let value = queryItem.value {
        switch queryItem.name {
        case "access_token":
          accessToken = value
        case "token_type":
          tokenType = value
        case "expires_in":
          expiresIn = value
        case "refresh_token":
          refreshToken = value
        case "scope":
          scope = value
        default:
          break
        }
      }
    }
  }

  func save(_ filename: String) throws {
    let data = try JSONSerialization.data(withJSONObject: self.asDictionary)
    try data.write(to: URL(fileURLWithPath: filename))
  }

  public init(json: JSON) {
    accessToken = json["access_token"].string
    tokenType = json["token_type"].string
    expiresIn = json["expires_in"].string
    refreshToken = json["refresh_token"].string
    scope = json["scope"].string
  }

  public var asDictionary: [String: String] {
    var dictionary: [String: String] = [:]
    dictionary["access_token"] = accessToken
    dictionary["token_type"] = tokenType
    dictionary["expires_in"] = expiresIn
    dictionary["refresh_token"] = refreshToken
    dictionary["scope"] = scope
    return dictionary
  }
}
