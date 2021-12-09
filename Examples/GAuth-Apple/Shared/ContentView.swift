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
import SwiftUI

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
      HStack {
        Button {
          token_refresh()
        } label: {
          Text("Refresh Token")
        }
        Button {
          token_cache_clear()
        } label: {
          Text("Clear Token Cache")
        }
      }
    }
    .padding()
    .background(WindowAccessor(window: $window))
  }
}

// MARK: previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
