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
  public var oAuthToken: String?
  public var oAuthTokenSecret: String?
  public var oAuthVerifier: String?
  public var returnAddress: String?
  public var screenName: String?
  public var userID: String?
  public var creationTime: Date?

  public init(urlComponents: URLComponents) {
    creationTime = Date()
    for queryItem in urlComponents.queryItems! {
      if let value = queryItem.value {
        switch queryItem.name {
        case "oauth_token":
          oAuthToken = value
        case "oauth_token_secret":
          oAuthTokenSecret = value
        case "oauth_verifier":
          oAuthVerifier = value
        case "screen_name":
          screenName = value
        case "user_id":
          userID = value
        case "oauth_callback_confirmed":
          break
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
    oAuthToken = json["oAuthToken"].string
    oAuthTokenSecret = json["oAuthTokenSecret"].string
  }

  public var asDictionary: [String: String] {
    var dictionary: [String: String] = [:]
    dictionary["oAuthToken"] = oAuthToken
    dictionary["oAuthTokenSecret"] = oAuthTokenSecret
    return dictionary
  }
}
