# Use Firebase Functions to Securely Obtain Auth Tokens

The FirebaseFunctionTokenProvider allows applications to obtain auth tokens
using service accounts without storing the service account credentials locally
within an application. Instead, an app is registered to use Firebase Functions
and calls a designated function that uses server-side calls to get an
authorization token from a Firebase Function. 

A sample Firebase Function implementation is in `index.js`. This sample uses
the Google Cloud Metadata Service to return an auth token associated with the
service account of the Firebase Function. It triggers push notification with 
payload (contains token and it's expiry time) along with Device ID via 
FCM(Firebase Cloud Messaging) which will be received by client.

