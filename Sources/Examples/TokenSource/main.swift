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
import OAuth2

let scopes = ["https://www.googleapis.com/auth/cloud-platform"]

if let provider = DefaultTokenProvider(scopes: scopes) {
  let sem = DispatchSemaphore(value: 0)
  try provider.withToken() {(token, error) -> Void in
    if let token = token {
      let encoder = JSONEncoder()
      if let token = try? encoder.encode(token) {
        print("\(String(data:token, encoding:.utf8)!)")
      }
    }
    if let error = error {
      print("ERROR \(error)")
    }
    sem.signal()
  }
  _ = sem.wait(timeout: DispatchTime.distantFuture)
} else {
  print("Unable to obtain an auth token.\nTry pointing GOOGLE_APPLICATION_CREDENTIALS to your service account credentials.")
}
