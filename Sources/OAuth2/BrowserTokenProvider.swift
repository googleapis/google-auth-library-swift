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

import Dispatch
import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif
import NIOHTTP1
import TinyHTTPServer

struct Credentials: Codable {
  let clientID: String
  let clientSecret: String
  let authorizeURL: String
  let accessTokenURL: String
  let callback: String
  enum CodingKeys: String, CodingKey {
    case clientID = "client_id"
    case clientSecret = "client_secret"
    case authorizeURL = "authorize_url"
    case accessTokenURL = "access_token_url"
    case callback
  }
}

public class BrowserTokenProvider: TokenProvider {
  private var credentials: Credentials
  private var code: Code?
  public var token: Token?

  private var sem: DispatchSemaphore?

  public convenience init?(credentials: String, token tokenfile: String) {
    let path = ProcessInfo.processInfo.environment["HOME"]!
      + "/.credentials/" + credentials
    let url = URL(fileURLWithPath: path)

    guard let credentialsData = try? Data(contentsOf: url) else {
      print("No credentials data at \(path).")
      return nil
    }
    self.init(credentials: credentialsData, token: tokenfile)
  }

  public init?(credentials: Data, token tokenfile: String) {
    let decoder = JSONDecoder()
    guard let credentials = try? decoder.decode(Credentials.self,
                                                from: credentials)
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
          return nil
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
  private func startServer(sem: DispatchSemaphore) throws {
    self.sem = sem

    try TinyHTTPServer().start { server, request -> (String, HTTPResponseStatus) in
      if request.uri.unicodeScalars.starts(with: self.credentials.callback.unicodeScalars) {
        server.stop()
        if let urlComponents = URLComponents(string: request.uri) {
          self.code = Code(urlComponents: urlComponents)
          DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            self.sem?.signal()
          }
          return ("success! Token received.\n", .ok)
        } else {
          return ("failed to get token.\n", .ok)
        }
      } else {
        return ("not found\n", .notFound)
      }
    }
  }

  private func exchange() throws -> Token {
    let sem = DispatchSemaphore(value: 0)
    let parameters = [
      "client_id": credentials.clientID, // some providers require the client id and secret in the method call
      "client_secret": credentials.clientSecret,
      "grant_type": "authorization_code",
      "code": code!.code!,
      "redirect_uri": "http://localhost:8080" + credentials.callback,
    ]
    let token = credentials.clientID + ":" + credentials.clientSecret
    // some providers require the client id and secret in the authorization header
    let authorization = "Basic " + String(data: token.data(using: .utf8)!.base64EncodedData(), encoding: .utf8)!
    var responseData: Data?
    var contentType: String?
    Connection.performRequest(
      method: "POST",
      urlString: credentials.accessTokenURL,
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
      return Token(urlComponents: urlComponents)
    }
  }

  @available(iOS 10.0, tvOS 10.0, *)
  public func signIn(scopes: [String]) throws {
    let sem = DispatchSemaphore(value: 0)
    try startServer(sem: sem)

    let state = UUID().uuidString
    let scope = scopes.joined(separator: " ")

    var urlComponents = URLComponents(string: credentials.authorizeURL)!
    urlComponents.queryItems = [
      URLQueryItem(name: "client_id", value: credentials.clientID),
      URLQueryItem(name: "response_type", value: "code"),
      URLQueryItem(name: "redirect_uri", value: "http://localhost:8080" + credentials.callback),
      URLQueryItem(name: "state", value: state),
      URLQueryItem(name: "scope", value: scope),
      URLQueryItem(name: "show_dialog", value: "false"),
    ]
    openURL(urlComponents.url!)
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    token = try exchange()
  }

  public func withToken(_ callback: @escaping (Token?, Error?) -> Void) throws {
    callback(token, nil)
  }
}
