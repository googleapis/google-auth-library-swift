# Token generator using firebase functions

FirebasFunctionTokenProvider swift file demonstrates how to generate auth token using following methods:

## withToken(_callback: @escaping (Token?, Error?) -> Void) throws
1.  It's a public function which accepts completion handler as input params.
2. Client (iOS app) will call this api.
3. This api will call "getToken" private function of FirebaseTokenService class.
4. It will call completion handler with either token on success or error message on failure.
 

## retrieveAccessToken(completionHandler: @escaping (Token?, Error?) -> Void)
1. This is a private function.
2. This func retrieves tokens from [index.js](https://github.com/google-auth-library-swift/tree/master/Sources/OAuth2/FirebaseFunctionTokenProvider/index.js) by calling its "getOAuthToken" api.
3. On failure it calls completion handler with error message.
4. On success it extracts the token data from the response, saves it in the UserDefauts for future reference and calls completionHandler with the token.

## isExpired() -> Bool
1. This is a private function used to validated the token.

##  private func getToken(_ callback: @escaping (Token?, Error?) -> Void) 
1. This will fetch the token from UserDefaults and call the isExpired func to validate it. 
2. If token is not expired then will call completion handler with the token.
3. If token is expired then it will:
    - Post notification "retreivingToken" so that client can show the activity indicator.
    - Anonymous sign in.
    - Call "retrieveAccessToken" private func to receive token.
    - On success, Post notification "tokenReceived" and completionHandler with the token.
    - On failure completionHandler with the error.

