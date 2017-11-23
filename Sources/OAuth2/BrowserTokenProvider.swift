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
  private var authorizeURL: String?
  private var accessTokenURL: String?
  private var callback: String?
  private var clientID: String?
  private var clientSecret: String?
  private var code: Code?
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
            case "authorize_url":
              authorizeURL = v
            case "access_token_url":
              accessTokenURL = v
            case "callback":
              callback = v
            case "client_id":
              clientID = v
            case "client_secret":
              clientSecret = v
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
        // ignore errors due to missing token files
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

    // Handle HTTP GET requests to the callback path
    router.get(callback!) {
      request, response, next in
      response.send("Hello!")

      let urlComponents = URLComponents(string: request.originalURL)!
      self.code = Code(urlComponents: urlComponents)
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

  private func exchange() throws -> Token {
    let sem = DispatchSemaphore(value: 0)
    var parameters = [
      "client_id": clientID!, // some providers require the client id and secret in the method call
      "client_secret": clientSecret!,
      "grant_type": "authorization_code",
      "code": code!.code!,
      "redirect_uri": "http://localhost:8080" + callback!,
      ]
    let token = clientID! + ":" + clientSecret!
    // some providers require the client id and secret in the authorization header
    let authorization = "Basic " + String(data: token.data(using: .utf8)!.base64EncodedData(), encoding: .utf8)!
    var responseData: Data?
    var contentType: String?
    Connection.performRequest(
      method: "POST",
      urlString: accessTokenURL!,
      parameters: &parameters,
      body: nil,
      authorization: authorization) { data, response, _ in
        if let c = (response as? HTTPURLResponse)!.allHeaderFields["Content-Type"] {
          contentType = c as? String
        }
        responseData = data
        sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    if contentType != nil && contentType!.contains("application/json") {

      let decoder = JSONDecoder()
      let token = try! decoder.decode(Token.self, from: responseData!)
      return token
    } else { // assume "application/x-www-form-urlencoded"
      let urlComponents = URLComponents(string: "http://example.com?" + String(data: responseData!, encoding: .utf8)!)!
      return Token(urlComponents: urlComponents)
    }
  }

  public func signIn(scopes: [String]) throws {
    let sem = DispatchSemaphore(value: 0)
    startServer(sem: sem)

    let state = UUID().uuidString
    let scope = scopes.joined(separator: " ")

    var urlComponents = URLComponents(string: authorizeURL!)!
    urlComponents.queryItems = [
      URLQueryItem(name: "client_id", value: clientID!),
      URLQueryItem(name: "response_type", value: "code"),
      URLQueryItem(name: "redirect_uri", value: "http://localhost:8080" + callback!),
      URLQueryItem(name: "state", value: state),
      URLQueryItem(name: "scope", value: scope),
      URLQueryItem(name: "show_dialog", value: "false"),
    ]
    openURL(urlComponents.url!)
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    token = try exchange()
  }
}
