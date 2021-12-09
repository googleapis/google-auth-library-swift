// Copyright 2021 Google LLC. All Rights Reserved.
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

#if os(macOS) || os(iOS)
import Dispatch
import Foundation
import AuthenticationServices

public struct NativeCredentials: Codable, CodeExchangeInfo, RefreshExchangeInfo {
  public let clientID: String
  let authorizeURL: String
  public let accessTokenURL: String
  let callbackScheme: String
  enum CodingKeys: String, CodingKey {
    case clientID = "client_id"
    case authorizeURL = "authorize_url"
    case accessTokenURL = "access_token_url"
    case callbackScheme = "callback_scheme"
  }
  var redirectURI: String {
    callbackScheme + ":/oauth2redirect"
  }
  public var clientSecret: String {
    ""
  }
}

@available(macOS 10.15.4, iOS 13.4, *)
public class PlatformNativeTokenProvider: TokenProvider {
  private var credentials: NativeCredentials
  private var session: Session?
  public var token: Token?

  // for parity with BrowserTokenProvider
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
    guard let credentials = try? decoder.decode(NativeCredentials.self,
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

  private struct Session {
    let webAuthSession: ASWebAuthenticationSession
    let webAuthContext: ASWebAuthenticationPresentationContextProviding
  }

  // The presentation context provides a reference to a UIWindow that the auth
  // framework uese to display the confirmation modal and sign in controller.
  public func signIn(
    scopes: [String],
    context: ASWebAuthenticationPresentationContextProviding,
    completion: @escaping (Token?, AuthError?) -> Void
  ) {
    let state = UUID().uuidString
    let scope = scopes.joined(separator: " ")
    var urlComponents = URLComponents(string: credentials.authorizeURL)!
    urlComponents.queryItems = [
      URLQueryItem(name: "client_id", value: credentials.clientID),
      URLQueryItem(name: "response_type", value: "code"),
      URLQueryItem(name: "redirect_uri", value: credentials.redirectURI),
      URLQueryItem(name: "state", value: state),
      URLQueryItem(name: "scope", value: scope),
    ]

    let session = ASWebAuthenticationSession(
      url: urlComponents.url!,
      callbackURLScheme: credentials.callbackScheme
    ) { url, err in
      defer { self.session = nil }
      if let e = err {
        completion(nil, .webSession(inner: e))
        return
      }
      guard let u = url else {
        // If err is nil, url should not be, and vice versa.
        completion(nil, .unknownError)
        return
      }
      let code = Code(urlComponents: URLComponents(string: u.absoluteString)!)
      do {
        self.token = try code.exchange(info: self.credentials)
        completion(self.token!, nil)
      } catch let ae as AuthError {
        completion(nil, ae)
      } catch {
        completion(nil, .unknownError)
      }
    }

    session.presentationContextProvider = context
    if !session.canStart {
      // This happens if the context provider is not set, or if the session has
      // already been started. We enforce correct usage so ignore.
      return
    }
    let success = session.start()
    if !success {
      // This doesn't happen unless the context is not set, disappears (it's a
      // weak ref internally), or the session was previously started, ignore.
      return
    }
    self.session = Session(webAuthSession: session, webAuthContext: context)
  }

  // Canceling the session dismisses the view controller if it is showing.
  public func cancelSignIn() {
    session?.webAuthSession.cancel()
    self.session = nil
  }

  public func withToken(_ callback: @escaping (Token?, Error?) -> Void) throws {
    callback(token, nil)
  }
}
#endif
