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

public struct Token : Codable {
  public var AccessToken : String?
  public var TokenType : String?
  public var ExpiresIn : Int?
  public var RefreshToken : String?
  public var Scope : String?
  public var CreationTime : Date?
  enum CodingKeys: String, CodingKey {
    case AccessToken = "access_token"
    case TokenType = "token_type"
    case ExpiresIn = "expires_in"
    case RefreshToken = "refresh_token"
    case Scope = "scope"
    case CreationTime = "creation_time"
  }
  
  func save(_ filename: String) throws {
    let encoder = JSONEncoder()
    let data = try encoder.encode(self)
    try data.write(to: URL(fileURLWithPath: filename))
  }
  
  public init(accessToken: String) {
    self.AccessToken = accessToken
  }
  
  public init(urlComponents: URLComponents) {
    CreationTime = Date()
    for queryItem in urlComponents.queryItems! {
      if let value = queryItem.value {
        switch queryItem.name {
        case "access_token":
          AccessToken = value
        case "token_type":
          TokenType = value
        case "expires_in":
          ExpiresIn = Int(value)
        case "refresh_token":
          RefreshToken = value
        case "scope":
          Scope = value
        default:
          break
        }
      }
    }
  }
}
