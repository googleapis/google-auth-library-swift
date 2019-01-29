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

struct Credentials : Codable {
  let clientID : String
  let clientSecret : String
  let authorizeURL : String
  let accessTokenURL : String
  let callback : String
  enum CodingKeys: String, CodingKey {
    case clientID = "client_id"
    case clientSecret = "client_secret"
    case authorizeURL = "authorize_url"
    case accessTokenURL = "access_token_url"
    case callback = "callback"
  }
}

public class BrowserTokenProvider: TokenProvider, HTTPServerResponder {
  private var credentials : Credentials
  private var code: Code?
  public var token: Token?

  private var sem: DispatchSemaphore?
  private var server: HTTPServer?

  public init?(credentials: String, token tokenfile: String) {
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
            throw AuthError.unknownError
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

  /// See `HTTPServerResponder`.
  public func respond(to req: HTTPRequest, on worker: Worker) -> Future<HTTPResponse> {
    if req.url.path == credentials.callback {
      let urlComponents = URLComponents(string: req.urlString)!
      self.code = Code(urlComponents: urlComponents)
      DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
        self.sem?.signal()
      }
      let res = HTTPResponse(body: "Success! Token received.\n")
      return worker.eventLoop.newSucceededFuture(result: res)
    } else {
      let res = HTTPResponse(body: "Unknown request: \(req.url.path)\n")
      return worker.eventLoop.newSucceededFuture(result: res)
    }
  }

  // StartServer starts a web server that listens on http://localhost:8080.
  // The webserver waits for an oauth code in the three-legged auth flow.
  private func startServer(sem: DispatchSemaphore) throws {
    self.sem = sem
    let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    self.server = try HTTPServer.start(
      hostname: "localhost",
      port: 8080,
      responder: self,
      on: group
      ).wait()
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
