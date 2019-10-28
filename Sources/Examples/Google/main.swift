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

let CREDENTIALS = "google.json"
let TOKEN = "google.json"

fileprivate enum CommandLineOption {
    case login
    case me
    case people
    case data
    case translate(text: String)
    init?(arguments: [String]) {
        if arguments.count > 1 {
            let command = arguments[1]
            switch command {
            case "login": self = .login
            case "me": self = .me
            case "people": self = .people
            case "data": self = .data
            case "translate":
                if arguments.count < 2 { return nil }
                self = .translate(text: arguments[2])
            default: return nil
            }
        } else {
            return nil
        }
    }
    func stringValue() -> String {
        switch self {
        case .login: return "login"
        case .me: return "me"
        case .people: return "people"
        case .data: return "data"
        case .translate(_): return "translate"
        }
    }

    static func all() -> [String] {
        return [CommandLineOption.login,
                CommandLineOption.me,
                CommandLineOption.people,
                CommandLineOption.data,
                CommandLineOption.translate(text: "")].map({$0.stringValue()})
    }
}

func main() throws {

    let arguments = CommandLine.arguments
    guard  let option = CommandLineOption(arguments: arguments) else {
        print("Usage: \(arguments[0]) [options]")
        print("Options list: \(CommandLineOption.all())")
        return
    }

    let scopes = ["profile",
                  "https://www.googleapis.com/auth/contacts.readonly",
                  "https://www.googleapis.com/auth/cloud-platform"]

    guard let browserTokenProvider = BrowserTokenProvider(credentials:CREDENTIALS, token:TOKEN) else {
      print("Unable to create token provider.")
      return
    }
    let google = try GoogleSession(tokenProvider:browserTokenProvider)

    switch option {
    case .login:
        try browserTokenProvider.signIn(scopes:scopes)
        try browserTokenProvider.saveToken(TOKEN)
    case .me:
        try google.getMe()
    case .people:
        try google.getPeople()
    case .data:
        try google.getData()
    case .translate(let text):
        try google.translate(text)
    }

}

do {
    try main()
} catch (let error) {
    print("ERROR: \(error)")
}
