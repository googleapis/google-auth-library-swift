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
import Dispatch
import HTTP
import CryptoSwift

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

struct AuthError : Error {
  
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
      return nil
    }
    let decoder = JSONDecoder()
    guard let credentials = try? decoder.decode(Credentials.self,
                                                from: credentialsData)
      else {
        return nil
    }
    self.credentials = credentials
    
    if tokenfile != "" {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: tokenfile))
        let decoder = JSONDecoder()
        guard let token = try? decoder.decode(Token.self, from: data)
          else {
            throw AuthError()
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
  
  func handler(request: HTTPRequest, response: HTTPResponseWriter ) -> HTTPBodyProcessing {
    let urlComponents = URLComponents(string: request.target)!
    let path = urlComponents.path
    if path == credentials.callback {
      self.token = Token(urlComponents: urlComponents)
      DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
        self.sem?.signal()
      }
      response.writeHeader(status: .ok)
      response.writeBody("Success! Token received.\n")
      response.done()
      return .discardBody
    } else {
      response.writeHeader(status: .ok)
      response.writeBody("Unknown request: \(path)\n")
      response.done()
      return .discardBody
    }
  }
  
  // StartServer starts a web server that listens on http://localhost:8080.
  // The webserver waits for an oauth code in the three-legged auth flow.
  private func startServer(sem: DispatchSemaphore) {
    self.sem = sem
    let server = HTTPServer()
    try! server.start(port: 8080, handler: handler)
  }
  
  public func signIn() throws {
    let sem = DispatchSemaphore(value: 0)
    startServer(sem: sem)
    
    let sem2 = DispatchSemaphore(value: 0)
    
    let parameters = ["oauth_callback": "http://localhost:8080" + credentials.callback]
    var responseData: Data?
    
    Connection.performRequest(
      method: "POST",
      urlString: credentials.requestTokenURL,
      parameters: parameters,
      tokenSecret: "",
      consumerKey: credentials.consumerKey,
      consumerSecret: credentials.consumerSecret) { data, _, _ in
        responseData = data
        sem2.signal()
    }
    _ = sem2.wait(timeout: DispatchTime.distantFuture)
    
    let params = String(data: responseData!, encoding: .utf8)
    
    var urlComponents = URLComponents(string: "http://example.com?" + params!)!
    token = Token(urlComponents: urlComponents)
    
    if true {
      urlComponents = URLComponents(string: credentials.authorizeURL)!
      urlComponents.queryItems = [URLQueryItem(name: "oauth_token", value: encode(token!.oAuthToken!))]
      openURL(urlComponents.url!)
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    try exchange()
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
