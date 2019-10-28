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
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct ServiceAccountCredentials : Codable {
  let CredentialType : String
  let ProjectId : String
  let PrivateKeyId : String
  let PrivateKey : String
  let ClientEmail : String
  let ClientID : String
  let AuthURI : String
  let TokenURI : String
  let AuthProviderX509CertURL : String
  let ClientX509CertURL : String
  enum CodingKeys: String, CodingKey {
    case CredentialType = "type"
    case ProjectId = "project_id"
    case PrivateKeyId = "private_key_id"
    case PrivateKey = "private_key"
    case ClientEmail = "client_email"
    case ClientID = "client_id"
    case AuthURI = "auth_uri"
    case TokenURI = "token_uri"
    case AuthProviderX509CertURL = "auth_provider_x509_cert_url"
    case ClientX509CertURL = "client_x509_cert_url"
  }
}

public class ServiceAccountTokenProvider : TokenProvider {
  public var token: Token?
  
  var credentials : ServiceAccountCredentials
  var scopes : [String]
  var rsaKey : RSAKey
  
  public init?(credentialsData:Data, scopes:[String]) {
    let decoder = JSONDecoder()
    guard let credentials = try? decoder.decode(ServiceAccountCredentials.self,
                                                from: credentialsData)
      else {
        return nil
    }
    self.credentials = credentials
    self.scopes = scopes
    guard let rsaKey = RSAKey(privateKey:credentials.PrivateKey)
      else {
        return nil
    }
    self.rsaKey = rsaKey
  }
  
  convenience public init?(credentialsURL:URL, scopes:[String]) {
    guard let credentialsData = try? Data(contentsOf:credentialsURL, options:[]) else {
      return nil
    }
    self.init(credentialsData:credentialsData, scopes:scopes)
  }
  
  public func withToken(_ callback:@escaping (Token?, Error?) -> Void) throws {
    let iat = Date()
    let exp = iat.addingTimeInterval(3600)
    let jwtClaimSet = JWTClaimSet(Issuer:credentials.ClientEmail,
                                  Audience:credentials.TokenURI,
                                  Scope:  scopes.joined(separator: " "),
                                  IssuedAt: Int(iat.timeIntervalSince1970),
                                  Expiration: Int(exp.timeIntervalSince1970))
    let jwtHeader = JWTHeader(Algorithm: "RS256",
                              Format: "JWT")
    let msg = try JWT.encodeWithRS256(jwtHeader:jwtHeader,
                                      jwtClaimSet:jwtClaimSet,
                                      rsaKey:rsaKey)
    let json: [String: Any] = ["grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                           "assertion": msg]
    let data = try? JSONSerialization.data(withJSONObject: json)    
  
    var urlRequest = URLRequest(url:URL(string:credentials.TokenURI)!)
    urlRequest.httpMethod = "POST"
    urlRequest.httpBody = data
    urlRequest.setValue("application/json", forHTTPHeaderField:"Content-Type")
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let task: URLSessionDataTask = session.dataTask(with:urlRequest)
    {(data, response, error) -> Void in
      let decoder = JSONDecoder()
      if let data = data,
        let token = try? decoder.decode(Token.self, from: data) {
        callback(token, error)
      } else {
        callback(nil, error)
      }
    }
    task.resume()
  }
}
