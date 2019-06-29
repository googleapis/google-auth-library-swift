//
//
// Copyright 2019 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import FirebaseFunctions
import FirebaseCore
import FirebaseAuth

struct TokenServiceConstants {
    static let token = "Token"
    static let accessToken = "accessToken"
    static let expireTime = "expireTime"
    static let tokenReceived = "tokenReceived"
    static let retreivingToken = "RetrievingToken"
    static let getTokenAPI = "getOAuthToken"
    static let tokenType = "Bearer "
    static let noTokenError = "No token is available"
}


public class FCMTokenProvider {
    
    static private func retrieveAccessToken(deviceID: String, completionHandler: @escaping (Error?) -> Void) {
        Functions.functions().httpsCallable(TokenServiceConstants.getTokenAPI).call(["deviceID": deviceID], completion: { (result, error) in
            if error != nil {
                completionHandler(error)
                return
            }
            guard let _: HTTPSCallableResult = result else {
                completionHandler("Result found nil" as? Error)
                return
            }
           completionHandler(nil)
        })
    }
    
    //This function compares token expiry date with current date
    //Returns bool value True if the token is expired else false
    static private func isExpired() -> Bool {
        guard let token = UserDefaults.standard.value(forKey: TokenServiceConstants.token) as? [String: String],
            let expDate = token[TokenServiceConstants.expireTime] else{
                return true
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let expiryDate = dateFormatter.date(from: expDate) else {
            return true
        }
        return (Date() > expiryDate)
    }
    
    //Return token from user defaults if token is there and not expired.
    //Request for new token if token is expired or not there in user defaults.
    //Return the newly generated token.
    static public func getToken(deviceID: String, _ callback: @escaping (_ shouldWait:Bool, _ token: String?, _ error: Error?) -> Void) {
        if isExpired() {
            NotificationCenter.default.post(name: NSNotification.Name(TokenServiceConstants.retreivingToken), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(tokenReceived(tokenData:)), name: NSNotification.Name(ApplicationConstants.tokenReceived), object: nil)
            //this sample uses Firebase Auth signInAnonymously and you can insert any auth signin that they offer.
            //FirebaseApp.configure()
            Auth.auth().signInAnonymously() { (authResult, error) in
                if error != nil {
                    //Sign in failed
                    callback(false, nil, error)
                    return
                }
                retrieveAccessToken(deviceID: deviceID, completionHandler: {(error) in
                    if let error = error {
                        callback(false, nil, error)
                    } else {
                        callback(true, nil, nil)
                    }
                })
            }
        } else {
            if let tokenData = UserDefaults.standard.value(forKey: TokenServiceConstants.token) as? [String: Any],
                let accessToken = tokenData[TokenServiceConstants.accessToken] as? String {
                let tokenModel = "\(TokenServiceConstants.tokenType)\(accessToken)"
                callback(false, tokenModel, nil)
            } else {
                UserDefaults.standard.set(nil, forKey: TokenServiceConstants.token)
                getToken(deviceID: deviceID, callback)
            }
        }
    }
    
    @objc private func tokenReceived(tokenData: [String: Any]) {
        UserDefaults.standard.set(tokenData, forKey: TokenServiceConstants.token)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ApplicationConstants.tokenReceived), object: nil)
    }
}

