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
import CryptoSwift
#if os(Linux) && swift(>=5.1)
import FoundationNetworking
#endif

public class Connection {
  
  public var provider : TokenProvider
  
  public init(provider : TokenProvider) throws {
    self.provider = provider
  }
  
  class func signOAuthRequest(
    method : String,
    urlString : String,
    parameters : inout [String:String],
    secret : String) {
    
    // sort the keys of the method call
    let sortedMethodKeys = Array(parameters.keys).sorted(by:<)
    
    // build the signature base string
    var presignature = ""
    
    for key in sortedMethodKeys {
      if presignature != "" {
        presignature += "&"
      }
      presignature += key + "=" + encode(parameters[key]!)
    }
    let signatureBaseString = method + "&" + encode(urlString) + "&" + encode(presignature)
    
    // generate the signature
    let hmac = try! CryptoSwift.HMAC(key: secret, variant: .sha1).authenticate(Array(signatureBaseString.utf8))
    parameters["oauth_signature"] = hmac.toBase64()!
  }
  
  public class func performRequest(
    method : String,
    urlString : String,
    parameters : [String:String],
    tokenSecret : String,
    consumerKey : String,
    consumerSecret : String,
    callback: @escaping (Data?, URLResponse?, Error?)->()) {
    
    // prepare the request for signing
    var parameters = parameters
    parameters["oauth_consumer_key"] = consumerKey
    parameters["oauth_version"] = "1.0"
    parameters["oauth_nonce"] = UUID().uuidString
    parameters["oauth_timestamp"] = String(Int(NSDate().timeIntervalSince1970))
    parameters["oauth_signature_method"] = "HMAC-SHA1"
    
    // sign the request
    signOAuthRequest(method:method, urlString:urlString, parameters:&parameters, secret:consumerSecret + "&" + tokenSecret)
    
    // sort the keys of the method call
    let sortedMethodKeys = Array(parameters.keys).sorted(by:<)
    
    // build the authorization string
    var authorization = "OAuth "
    var i = 0
    for key in sortedMethodKeys {
      if key.hasPrefix("oauth_") {
        if i > 0 {
          authorization += ", "
        }
        authorization += key + "=\"" + encode(parameters[key]!) + "\""
        i += 1
      }
    }
    
    var urlComponents = URLComponents(string:urlString)!
    var queryItems : [URLQueryItem] = []
    for key in sortedMethodKeys {
      if !key.hasPrefix("oauth_") {
        queryItems.append(URLQueryItem(name: key, value: parameters[key]))
      }
    }
    urlComponents.queryItems = queryItems
    
    var request = URLRequest(url: urlComponents.url!)
    request.setValue(authorization, forHTTPHeaderField:"Authorization")
    request.httpMethod = method
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let task: URLSessionDataTask = session.dataTask(with:request) { (data, response, error) -> Void in
      callback(data, response, error)
    }
    task.resume()
  }
  
  public func performRequest(
    method : String,
    urlString : String,
    parameters : [String:String],
    callback: @escaping (Data?, URLResponse?, Error?)->()) throws {
    
    try provider.withToken() {(token, consumerKey, consumerSecret, err) in
      guard let token = token else {
        return
      }
      guard let oAuthToken = token.oAuthToken,
        let oAuthTokenSecret = token.oAuthTokenSecret else {
          return
      }
      var parameters = parameters
      parameters["oauth_token"] = oAuthToken
      Connection.performRequest(
        method: method,
        urlString: urlString,
        parameters: parameters,
        tokenSecret: oAuthTokenSecret,
        consumerKey: consumerKey!,
        consumerSecret: consumerSecret!,
        callback: callback)
    }
  }
  
  public func performRequest(
    method : String,
    urlString : String,
    callback: @escaping (Data?, URLResponse?, Error?)->()) throws {
    let parameters : [String:String] = [:]
    try self.performRequest(method:method, urlString:urlString, parameters:parameters, callback:callback)
  }
  
}
