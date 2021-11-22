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

import SwiftUI
import OAuth2
import AuthenticationServices

struct ContentView: View {

  @State private var window: ASPresentationAnchor?

  var body: some View {
    VStack {
      HStack { Spacer().frame(maxWidth: .infinity) }
      Text("GAuth Example")
      Divider()
      Spacer()

      Button(action: {
        oauth2_browser()
      }) {
        Text("Login Browser")
      }

      Divider()
        .padding()
        .frame(maxWidth: 120)

      Button(action: {
        oauth2_native(anchor: window!)
      }) {
        Text("Login Native")
      }
      Spacer()
    }
    .padding()
    .background(WindowAccessor(window: $window))
  }
}

// MARK: oauth2 browser

#error("add OAuth2 <client_id> from https://console.cloud.google.com/apis/credentials")
let creds = """
{
  "client_id": "<client of type native/iosOS>",
  "client_secret": "",
  "authorize_url": "https://accounts.google.com/o/oauth2/auth",
  "access_token_url": "https://accounts.google.com/o/oauth2/token",
  "callback": "/google/callback"
}
"""

func oauth2_browser() {
  let cdata = creds.data(using: .utf8)!
  guard let tp = BrowserTokenProvider(credentials: cdata, token: "")
  else {
    print("error creating browser token provider")
    return
  }
  do {
    let readonly = "https://www.googleapis.com/auth/gmail.readonly"
    try tp.signIn(scopes: [readonly])
  } catch let e {
    print("error signing in: \(e)")
    return
  }

  query_gmail(tp)
}

// MARK: oauth2 native

#error("add OAuth2 <client_id> and <callback_scheme> from https://console.cloud.google.com/apis/credentials")
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
  guard let tp = PlatformNativeTokenProvider(credentials: cdata, token: "")
  else {
    print("error creating browser token provider")
    return
  }
  let readonly = "https://www.googleapis.com/auth/gmail.readonly"

  let ctx = AuthContext(anchor: a)
  tp.signIn(scopes: [readonly], context: ctx) {
    if let token = $0 {
      print("token: \(token)")
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

// MARK: previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
