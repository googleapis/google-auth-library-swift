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
import OAuth1

class TwitterSession {
  public var connection : Connection

  init(tokenSource: TokenSource) throws{
    connection = try Connection(source:tokenSource)
  }

  func getTweets() throws {
    let sem = DispatchSemaphore(value: 0)
    var responseData : Data?
    try connection.performRequest(
      method:"GET",
      urlString:"https://api.twitter.com/1.1/statuses/user_timeline.json") {(data, response, error) in
        responseData = data
        sem.signal()
    }
    _ = sem.wait(timeout: DispatchTime.distantFuture)
    if let data = responseData {
      let response = String(data: data, encoding: .utf8)!
      print(response)
    }
  }
}
