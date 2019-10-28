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

import Foundation
import OAuth2

let CREDENTIALS = "meetup.json"
let TOKEN = "meetup.json"

func main() throws {
  let arguments = CommandLine.arguments
  
  if arguments.count == 1 {
    print("Usage: \(arguments[0]) [options]")
    return
  }
  
  guard let tokenProvider = BrowserTokenProvider(credentials:CREDENTIALS, token:TOKEN) else {
    print("Unable to create token provider.")
    return
  }

  let meetup = try MeetupSession(tokenProvider:tokenProvider)
  
  if arguments[1] == "login" {
    try tokenProvider.signIn(scopes:["basic", "ageless"])
    try tokenProvider.saveToken(TOKEN)
  }
  
  if arguments[1] == "me" {
    try meetup.getMe()
  }
  
  if arguments[1] == "rsvps" {
    try meetup.getRSVPs(eventid:arguments[2])
  }
  
  if arguments[1] == "events" {
    try meetup.getEvents()
  }
}

do {
  try main()
} catch (let error) {
  print("ERROR: \(error)")
}

