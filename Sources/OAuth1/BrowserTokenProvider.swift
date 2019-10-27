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
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Dispatch
import CryptoSwift
import TinyHTTPServer
import NIOHTTP1

struct Credentials : Codable {
  let consumerKey : String
  let consumerSecret : String
  let requestTokenURL : String
  let authorizeURL : String
  let accessTokenURL : String
  let callback : String
  enum CodingKeys: String, CodingKey {
    case consumerKey = "consumer_key"
    case consumerSecret = "consumer_secret"
    case requestTokenURL = "request_token_url"
    case authorizeURL = "authorize_url"
    case accessTokenURL = "access_token_url"
    case callback = "callback"
  }
}

enum AuthError : Error {
  case invalidTokenFile
  case tokenRequestFailed
}

public class BrowserTokenProvider : TokenProvider {
  private var credentials : Credentials
  public var token: Token?
  
  private var sem: DispatchSemaphore?

  public init?(credentials: String, token tokenfile: String) throws {
    let path = ProcessInfo.processInfo.environment["HOME"]!
      + "/.credentials/" + credentials
    let url = URL(fileURLWithPath:path)
    
    guard let credentialsData = try? Data(contentsOf:url) else {
      print("No credentials data at \(path)")
      return nil
    }
    let decoder = JSONDecoder()
    guard let credentials = try? decoder.decode(Credentials.self,
                                                from: credentialsData)
      else {
        print("Error reading credentials")
        return nil
    }
    self.credentials = credentials
    
    if tokenfile != "" {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: tokenfile))
        let decoder = JSONDecoder()
        guard let token = try? decoder.decode(Token.self, from: data)
          else {
            throw AuthError.invalidTokenFile
        }
        self.token = token
      } catch {
        // ignore errors due to missing session files
      }
    }
  }
  
  public func saveToken(_ filename: String) throws {
    if let token = token {
      try token.save(filename)
    }
  }

  // StartServer starts a web server that listens on http://localhost:8080.
  // The webserver waits for an oauth code in the three-legged auth flow.
  private func startServer(sem: DispatchSemaphore) throws {
    self.sem = sem

    try TinyHTTPServer().start() { server, request -> (String, HTTPResponseStatus) in
      if request.uri.unicodeScalars.starts(with:self.credentials.callback.unicodeScalars) {
        server.stop()
        if let urlComponents = URLComponents(string: request.uri) {
          self.token = Token(urlComponents: urlComponents)
          DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            self.sem?.signal()
          }
          return ("success! Token received.\n", .ok)
        } else {
          return ("failed to get token.\n", .ok)
        }
      } else  {
        return ("not found\n", .notFound)
      }
    }
  }
  
  public func signIn() throws {
    let sem = DispatchSemaphore(value: 0)
    try startServer(sem: sem)

    let sem2 = DispatchSemaphore(value: 0)
    
    let parameters = ["oauth_callback": "http://localhost:8080" + credentials.callback]

    var data: Data?
    var response: HTTPURLResponse?
    var error : Error?
    
    Connection.performRequest(
      method: "POST",
      urlString: credentials.requestTokenURL,
      parameters: parameters,
      tokenSecret: "",
      consumerKey: credentials.consumerKey,
      consumerSecret: credentials.consumerSecret) { d, r, e in
        data = d
        response = r as! HTTPURLResponse?
        error = e
        sem2.signal()
    }
    _ = sem2.wait(timeout: DispatchTime.distantFuture)
    
    if let error = error {
      throw error
    }

    if let response = response,
      let data = data {
      if response.statusCode != 200 {
        throw AuthError.tokenRequestFailed
      }
      guard let params = String(data: data, encoding: .utf8) else {
        throw AuthError.tokenRequestFailed
      }
      
      token = Token(urlComponents: URLComponents(string: "http://example.com?" + params)!)
      
      var urlComponents = URLComponents(string: credentials.authorizeURL)!
      urlComponents.queryItems = [URLQueryItem(name: "oauth_token", value: encode(token!.oAuthToken!))]
      openURL(urlComponents.url!)
      _ = sem.wait(timeout: DispatchTime.distantFuture)
      try exchange()
    } else {
      throw AuthError.tokenRequestFailed
    }
  }
  
  private func exchange() throws {
    let sem = DispatchSemaphore(value: 0)
    let parameters = [
      "oauth_token": token!.oAuthToken!,
      "oauth_verifier": token!.oAuthVerifier!,
      ]
    var responseData: Data?
    Connection.performRequest(
      method: "POST",
      urlString: credentials.accessTokenURL,
      parameters: parameters,
      tokenSecret: "",
      consumerKey: credentials.consumerKey,
      consumerSecret: credentials.consumerSecret) { data, _, _ in
        responseData = data
        sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    let urlComponents = URLComponents(string: "http://example.com?" + String(data: responseData!, encoding: .utf8)!)!
    token = Token(urlComponents: urlComponents)
  }
  
  public func withToken(_ callback:@escaping (Token?, String?, String?, Error?) -> Void) throws {
    callback(token, credentials.consumerKey, credentials.consumerSecret, nil)
  }
}
