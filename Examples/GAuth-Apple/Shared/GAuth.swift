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

import AuthenticationServices
import Foundation
import OAuth2

// MARK: setup overview

// You'll want to create a new demo/example project in the cloud console. Then,
// navigate to the cloud console api credentials page and configure the consent
// screen. A workspace internal screen will get you going quickly and does not
// require review, however you'll only be able to use your own workspace email
// addresses to complete the oauth flow until you configure an external screen.
//
//     https://console.cloud.google.com/apis/credentials
//
// Create an OAuth client ID crediential. An iOS credential works fine for both
// these example flows (the browser flow doesn't need a "browser" credential).
//
// Plug the correct credential values into the inline JSON below. You
// can copy the correct values from the console UI or download the credential
// file and take the values from there.
//
// Enable the appropriate API for your project in the cloud console. This
// example uses the Gmail API to get a list of your 50 most recent message IDs.
//
//     https://console.cloud.google.com/apis/library/gmail.googleapis.com
//
// Review the Google OAuth2 overview for further details:
//
//     https://developers.google.com/identity/protocols/oauth2

// MARK: oauth2 browser

#error("add OAuth2 <client_id> from cloud console api credentials page")
let creds_browser = """
{
  "client_id": "<client of type native/iosOS>",
  "client_secret": "",
  "authorize_url": "https://accounts.google.com/o/oauth2/auth",
  "access_token_url": "https://accounts.google.com/o/oauth2/token",
  "callback": "/google/callback"
}
"""

func oauth2_browser() {
  let cdata = creds_browser.data(using: .utf8)!
  let tfile = token_cache_url()?.path ?? ""
  guard let tp = BrowserTokenProvider(credentials: cdata, token: tfile)
  else {
    print("error creating browser token provider")
    return
  }

  if tp.token != nil {
    print("using existing token")
    query_gmail(tp)
    return
  }

  print("requesting new token")
  do {
    let readonly = "https://www.googleapis.com/auth/gmail.readonly"
    try tp.signIn(scopes: [readonly])
  } catch let e {
    print("error signing in: \(e)")
    return
  }
  try! tp.saveToken(tfile)

  query_gmail(tp)
}

// MARK: oauth2 native

#error("add OAuth2 <client_id> and <callback_scheme> from cloud console api credentials page")
let creds_native = """
{
  "client_id": "<client of type native/iOS>",
  "authorize_url": "https://accounts.google.com/o/oauth2/auth",
  "access_token_url": "https://accounts.google.com/o/oauth2/token",
  "callback_scheme": "<labeled: iOS URL Scheme, the reversed client-id>"
}
"""

func oauth2_native(anchor a: ASPresentationAnchor) {
  let cdata = creds_native.data(using: .utf8)!
  let tfile = token_cache_url()?.path ?? ""
  guard let tp = PlatformNativeTokenProvider(credentials: cdata, token: tfile)
  else {
    print("error creating native token provider")
    return
  }

  if tp.token != nil {
    print("using existing token")
    query_gmail(tp)
    return
  }

  print("requesting new token")
  let ctx = AuthContext(anchor: a)
  let readonly = "https://www.googleapis.com/auth/gmail.readonly"
  tp.signIn(scopes: [readonly], context: ctx) {
    if let token = $0 {
      print("token: \(token)")
      try! tp.saveToken(tfile)
      query_gmail(tp)
    } else {
      print("error signing in: \($1!)")
    }
  }
}

class AuthContext: NSObject, ASWebAuthenticationPresentationContextProviding {
  let anchor: ASPresentationAnchor
  init(anchor: ASPresentationAnchor) {
    self.anchor = anchor
  }
  func presentationAnchor(for session: ASWebAuthenticationSession)
  -> ASPresentationAnchor {
    return self.anchor
  }
}

// MARK: query gmail

func query_gmail(_ tp: TokenProvider) {
  print("Listing Gmail Messages")
  let g = Gmail(tokenProvider: tp)
  do {
    let params = Gmail.users_messageslistParameters(
      includeSpamTrash: false,
      labelIds: nil,
      maxResults: 50,
      pageToken: nil,
      q: nil,
      userId: "me"
    )
    try g.users_messages_list(parameters: params) { resp, err in
      resp.map { print("Response: \n\($0)") }
      err.map { print("Error: \n\($0)") }
    }
  } catch let e {
    print("error listing messages: \(e)")
  }
}

func token_cache_url() -> URL? {
  FileManager.default
    .urls(for: .cachesDirectory, in: .userDomainMask).first?
    .appendingPathComponent("gauth-token.json")
}

func token_cache_clear() {
  if let url = token_cache_url() {
    try? FileManager.default.removeItem(at: url)
  }
}
