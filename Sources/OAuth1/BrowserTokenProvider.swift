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
import Yaml
import Kitura
import CryptoSwift

struct AuthError : Error {

}

public class BrowserTokenProvider: TokenProvider {
  public var consumerKey: String?
  public var consumerSecret: String?
  private var requestTokenURL: String?
  private var authorizeURL: String?
  private var accessTokenURL: String?
  private var callback: String?
  public var token: Token?

  public init(credentials: String, token tokenfile: String) throws {
    let path = ProcessInfo.processInfo.environment["HOME"]!
      + "/.credentials/" + credentials
    let data = try String(contentsOfFile: path, encoding: .utf8)
    let yaml = try Yaml.load(data)
    switch yaml {
    case let .dictionary(d):
      for (key, value) in d {
        switch key {
        case let .string(k):
          if let v = value.string {
            switch k {
            case "consumer_key":
              consumerKey = v
            case "consumer_secret":
              consumerSecret = v
            case "request_token_url":
              requestTokenURL = v
            case "authorize_url":
              authorizeURL = v
            case "access_token_url":
              accessTokenURL = v
            case "callback":
              callback = v
            case "access_token_url":
              accessTokenURL = v
            default: break
            }
          }
        default: break
        }
      }
    default: break
    }

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

  // StartServer starts a web server that listens on http://localhost:8080.
  // The webserver waits for an oauth code in the three-legged auth flow.
  private func startServer(sem: DispatchSemaphore) {
    // Create a new router
    let router = Router()

    // Handle HTTP GET requests to /
    router.get(callback!) {
      request, response, next in
      response.send("Hello, user!")

      let urlComponents = URLComponents(string: request.originalURL)!

      self.token = Token(urlComponents: urlComponents)
      next()

      DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        Kitura.stop()
        sem.signal()
      }
    }

    // Add an HTTP server and connect it to the router
    Kitura.addHTTPServer(onPort: 8080, with: router)

    // Start the Kitura runloop on a separate thread
    DispatchQueue.global().async {
      Kitura.run()
    }
  }

  public func signIn() throws {
    let sem = DispatchSemaphore(value: 0)
    startServer(sem: sem)

    let sem2 = DispatchSemaphore(value: 0)

    var parameters = ["oauth_callback": "http://localhost:8080" + callback!]
    var responseData: Data?

    Connection.performRequest(
      method: "POST",
      urlString: requestTokenURL!,
      parameters: &parameters,
      tokenSecret: "",
      consumerKey: consumerKey!,
      consumerSecret: consumerSecret!) { data, _, _ in
        responseData = data
        sem2.signal()
    }
    _ = sem2.wait(timeout: DispatchTime.distantFuture)

    let params = String(data: responseData!, encoding: .utf8)

    var urlComponents = URLComponents(string: "http://example.com?" + params!)!
    token = Token(urlComponents: urlComponents)

    if true {
      urlComponents = URLComponents(string: authorizeURL!)!
      urlComponents.queryItems = [URLQueryItem(name: "oauth_token", value: encode(token!.oAuthToken!))]
      openURL(urlComponents.url!)
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    try exchange()
  }

  private func exchange() throws {
    let sem = DispatchSemaphore(value: 0)
    var parameters = [
      "oauth_token": token!.oAuthToken!,
      "oauth_verifier": token!.oAuthVerifier!,
      ]
    var responseData: Data?
    Connection.performRequest(
      method: "POST",
      urlString: accessTokenURL!,
      parameters: &parameters,
      tokenSecret: "",
      consumerKey: consumerKey!,
      consumerSecret: consumerSecret!) { data, _, _ in
        responseData = data
        sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    let urlComponents = URLComponents(string: "http://example.com?" + String(data: responseData!, encoding: .utf8)!)!
    token = Token(urlComponents: urlComponents)
  }
}
