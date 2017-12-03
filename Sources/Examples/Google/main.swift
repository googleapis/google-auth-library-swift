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

let CREDENTIALS = "google.json"
let TOKEN = "google.json"

func main() throws {
  let arguments = CommandLine.arguments

  if arguments.count == 1 {
    print("Usage: \(arguments[0]) [options]")
    return
  }

  #if os(OSX)
    let tokenProvider = try BrowserTokenProvider(credentials:CREDENTIALS, token:TOKEN)!
  #else
    let tokenProvider = try GoogleCloudMetadataTokenProvider()
  #endif

  let google = try GoogleSession(tokenProvider:tokenProvider)

  if arguments[1] == "login" {
    #if os(OSX)
      try tokenProvider.signIn(scopes:["profile", "https://www.googleapis.com/auth/contacts.readonly", "https://www.googleapis.com/auth/cloud-platform"])
      try tokenProvider.saveToken(TOKEN)
    #endif
  }

  if arguments[1] == "me" {
    try google.getMe()
  }

  if arguments[1] == "people" {
    try google.getPeople()
  }

  if arguments[1] == "data" {
    try google.getData()
  }

  if arguments[1] == "translate" && arguments.count > 2 {
    let text = arguments[2]
    try google.translate(text)
  }
}

do {
  try main()
} catch (let error) {
  print("ERROR: \(error)")
}

