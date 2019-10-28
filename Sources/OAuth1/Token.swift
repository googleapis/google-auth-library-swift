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

public struct Token : Codable {
  public var oAuthToken: String?
  public var oAuthTokenSecret: String?
  public var oAuthVerifier: String?
  public var returnAddress: String?
  public var screenName: String?
  public var userID: String?
  public var creationTime: Date?
  
  enum CodingKeys: String, CodingKey {
    case oAuthToken = "oauth_token"
    case oAuthTokenSecret = "oauth_token_secret"
    case oAuthVerifier = "oauth_verifier"
    case returnAddress = "return_address"
    case screenName = "screen_name"
    case userID = "user_id"
    case creationTime = "creation_time"
  }
  
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
    let encoder = JSONEncoder()
    let data = try encoder.encode(self)
    try data.write(to: URL(fileURLWithPath: filename))
  }
}
