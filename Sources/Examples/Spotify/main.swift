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
import OAuth2

let CREDENTIALS = "spotify.yaml"
let TOKEN = "spotify.json"

func main() throws {
  let arguments = CommandLine.arguments

  if arguments.count == 1 {
    print("Usage: \(arguments[0]) [options]")
    return
  }

  let tokenSource = try BrowserTokenSource(credentials:CREDENTIALS, token:TOKEN)

  let spotify = try SpotifySession(tokenSource:tokenSource)

  if arguments[1] == "login" {
    try tokenSource.signIn(scopes:["playlist-read-private",
                                     "playlist-modify-public",
                                     "playlist-modify-private",
                                     "user-library-read",
                                     "user-library-modify",
                                     "user-read-private",
                                     "user-read-email"])
    try tokenSource.saveToken(TOKEN)
  }

  if arguments[1] == "me" {
    try spotify.getUser()
  }

  if arguments[1] == "tracks" {
    try spotify.getTracks()
  }
}

do {
  try main()
} catch (let error) {
  print("ERROR: \(error)")
}

