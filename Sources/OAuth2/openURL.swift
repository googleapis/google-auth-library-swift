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
#if os(OSX)
  import Cocoa
#endif

private func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.executableURL = URL(string:"/usr/bin/env")
    task.arguments = args
    do {
        try task.run()
    } catch {
        return -1
    }
    task.waitUntilExit()
    return task.terminationStatus
}

internal func openURL(_ url: URL) {
  #if os(OSX)
    if !NSWorkspace.shared.open(url) {
      print("default browser could not be opened")
    }
  #else // Linux, tested on Ubuntu
    let status = shell("xdg-open", String(describing:url))
    if status != 0 {
    	print("To continue, please open this URL in your browser: (\(String(describing:url)))")
    }
  #endif
}
