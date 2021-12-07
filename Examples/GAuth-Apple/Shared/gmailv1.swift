// Copyright 2019 Google Inc. All Rights Reserved.
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

// NOTE: This file is automatically-generated!
//
// see: https://github.com/googleapis/google-api-swift-client

import Foundation
import OAuth2
import GoogleAPIRuntime

public class Gmail : Service {
    public init(tokenProvider: TokenProvider) {
        super.init(tokenProvider, "https://gmail.googleapis.com/")
    }

    public class AutoForwarding: Codable {
        public init (`disposition`: String?, `emailAddress`: String?, `enabled`: Bool?) {
            self.`disposition` = `disposition`
            self.`emailAddress` = `emailAddress`
            self.`enabled` = `enabled`
        }
        public var `disposition`: String?
        public var `emailAddress`: String?
        public var `enabled`: Bool?
    }

    public class BatchDeleteMessagesRequest: Codable {
        public init (`ids`: [String]?) {
            self.`ids` = `ids`
        }
        public var `ids`: [String]?
    }

    public class BatchModifyMessagesRequest: Codable {
        public init (`addLabelIds`: [String]?, `ids`: [String]?, `removeLabelIds`: [String]?) {
            self.`addLabelIds` = `addLabelIds`
            self.`ids` = `ids`
            self.`removeLabelIds` = `removeLabelIds`
        }
        public var `addLabelIds`: [String]?
        public var `ids`: [String]?
        public var `removeLabelIds`: [String]?
    }

    public class Delegate: Codable {
        public init (`delegateEmail`: String?, `verificationStatus`: String?) {
            self.`delegateEmail` = `delegateEmail`
            self.`verificationStatus` = `verificationStatus`
        }
        public var `delegateEmail`: String?
        public var `verificationStatus`: String?
    }

    public class Draft: Codable {
        public init (`id`: String?, `message`: Message?) {
            self.`id` = `id`
            self.`message` = `message`
        }
        public var `id`: String?
        public var `message`: Message?
    }

    public class Filter: Codable {
        public init (`action`: FilterAction?, `criteria`: FilterCriteria?, `id`: String?) {
            self.`action` = `action`
            self.`criteria` = `criteria`
            self.`id` = `id`
        }
        public var `action`: FilterAction?
        public var `criteria`: FilterCriteria?
        public var `id`: String?
    }

    public class FilterAction: Codable {
        public init (`addLabelIds`: [String]?, `forward`: String?, `removeLabelIds`: [String]?) {
            self.`addLabelIds` = `addLabelIds`
            self.`forward` = `forward`
            self.`removeLabelIds` = `removeLabelIds`
        }
        public var `addLabelIds`: [String]?
        public var `forward`: String?
        public var `removeLabelIds`: [String]?
    }

    public class FilterCriteria: Codable {
        public init (`excludeChats`: Bool?, `from`: String?, `hasAttachment`: Bool?, `negatedQuery`: String?, `query`: String?, `size`: Int?, `sizeComparison`: String?, `subject`: String?, `to`: String?) {
            self.`excludeChats` = `excludeChats`
            self.`from` = `from`
            self.`hasAttachment` = `hasAttachment`
            self.`negatedQuery` = `negatedQuery`
            self.`query` = `query`
            self.`size` = `size`
            self.`sizeComparison` = `sizeComparison`
            self.`subject` = `subject`
            self.`to` = `to`
        }
        public var `excludeChats`: Bool?
        public var `from`: String?
        public var `hasAttachment`: Bool?
        public var `negatedQuery`: String?
        public var `query`: String?
        public var `size`: Int?
        public var `sizeComparison`: String?
        public var `subject`: String?
        public var `to`: String?
    }

    public class ForwardingAddress: Codable {
        public init (`forwardingEmail`: String?, `verificationStatus`: String?) {
            self.`forwardingEmail` = `forwardingEmail`
            self.`verificationStatus` = `verificationStatus`
        }
        public var `forwardingEmail`: String?
        public var `verificationStatus`: String?
    }

    public class History: Codable {
        public init (`id`: String?, `labelsAdded`: [HistoryLabelAdded]?, `labelsRemoved`: [HistoryLabelRemoved]?, `messages`: [Message]?, `messagesAdded`: [HistoryMessageAdded]?, `messagesDeleted`: [HistoryMessageDeleted]?) {
            self.`id` = `id`
            self.`labelsAdded` = `labelsAdded`
            self.`labelsRemoved` = `labelsRemoved`
            self.`messages` = `messages`
            self.`messagesAdded` = `messagesAdded`
            self.`messagesDeleted` = `messagesDeleted`
        }
        public var `id`: String?
        public var `labelsAdded`: [HistoryLabelAdded]?
        public var `labelsRemoved`: [HistoryLabelRemoved]?
        public var `messages`: [Message]?
        public var `messagesAdded`: [HistoryMessageAdded]?
        public var `messagesDeleted`: [HistoryMessageDeleted]?
    }

    public class HistoryLabelAdded: Codable {
        public init (`labelIds`: [String]?, `message`: Message?) {
            self.`labelIds` = `labelIds`
            self.`message` = `message`
        }
        public var `labelIds`: [String]?
        public var `message`: Message?
    }

    public class HistoryLabelRemoved: Codable {
        public init (`labelIds`: [String]?, `message`: Message?) {
            self.`labelIds` = `labelIds`
            self.`message` = `message`
        }
        public var `labelIds`: [String]?
        public var `message`: Message?
    }

    public class HistoryMessageAdded: Codable {
        public init (`message`: Message?) {
            self.`message` = `message`
        }
        public var `message`: Message?
    }

    public class HistoryMessageDeleted: Codable {
        public init (`message`: Message?) {
            self.`message` = `message`
        }
        public var `message`: Message?
    }

    public class ImapSettings: Codable {
        public init (`autoExpunge`: Bool?, `enabled`: Bool?, `expungeBehavior`: String?, `maxFolderSize`: Int?) {
            self.`autoExpunge` = `autoExpunge`
            self.`enabled` = `enabled`
            self.`expungeBehavior` = `expungeBehavior`
            self.`maxFolderSize` = `maxFolderSize`
        }
        public var `autoExpunge`: Bool?
        public var `enabled`: Bool?
        public var `expungeBehavior`: String?
        public var `maxFolderSize`: Int?
    }

    public class Label: Codable {
        public init (`color`: LabelColor?, `id`: String?, `labelListVisibility`: String?, `messageListVisibility`: String?, `messagesTotal`: Int?, `messagesUnread`: Int?, `name`: String?, `threadsTotal`: Int?, `threadsUnread`: Int?, `type`: String?) {
            self.`color` = `color`
            self.`id` = `id`
            self.`labelListVisibility` = `labelListVisibility`
            self.`messageListVisibility` = `messageListVisibility`
            self.`messagesTotal` = `messagesTotal`
            self.`messagesUnread` = `messagesUnread`
            self.`name` = `name`
            self.`threadsTotal` = `threadsTotal`
            self.`threadsUnread` = `threadsUnread`
            self.`type` = `type`
        }
        public var `color`: LabelColor?
        public var `id`: String?
        public var `labelListVisibility`: String?
        public var `messageListVisibility`: String?
        public var `messagesTotal`: Int?
        public var `messagesUnread`: Int?
        public var `name`: String?
        public var `threadsTotal`: Int?
        public var `threadsUnread`: Int?
        public var `type`: String?
    }

    public class LabelColor: Codable {
        public init (`backgroundColor`: String?, `textColor`: String?) {
            self.`backgroundColor` = `backgroundColor`
            self.`textColor` = `textColor`
        }
        public var `backgroundColor`: String?
        public var `textColor`: String?
    }

    public class LanguageSettings: Codable {
        public init (`displayLanguage`: String?) {
            self.`displayLanguage` = `displayLanguage`
        }
        public var `displayLanguage`: String?
    }

    public class ListDelegatesResponse: Codable {
        public init (`delegates`: [Delegate]?) {
            self.`delegates` = `delegates`
        }
        public var `delegates`: [Delegate]?
    }

    public class ListDraftsResponse: Codable {
        public init (`drafts`: [Draft]?, `nextPageToken`: String?, `resultSizeEstimate`: Int?) {
            self.`drafts` = `drafts`
            self.`nextPageToken` = `nextPageToken`
            self.`resultSizeEstimate` = `resultSizeEstimate`
        }
        public var `drafts`: [Draft]?
        public var `nextPageToken`: String?
        public var `resultSizeEstimate`: Int?
    }

    public class ListFiltersResponse: Codable {
        public init (`filter`: [Filter]?) {
            self.`filter` = `filter`
        }
        public var `filter`: [Filter]?
    }

    public class ListForwardingAddressesResponse: Codable {
        public init (`forwardingAddresses`: [ForwardingAddress]?) {
            self.`forwardingAddresses` = `forwardingAddresses`
        }
        public var `forwardingAddresses`: [ForwardingAddress]?
    }

    public class ListHistoryResponse: Codable {
        public init (`history`: [History]?, `historyId`: String?, `nextPageToken`: String?) {
            self.`history` = `history`
            self.`historyId` = `historyId`
            self.`nextPageToken` = `nextPageToken`
        }
        public var `history`: [History]?
        public var `historyId`: String?
        public var `nextPageToken`: String?
    }

    public class ListLabelsResponse: Codable {
        public init (`labels`: [Label]?) {
            self.`labels` = `labels`
        }
        public var `labels`: [Label]?
    }

    public class ListMessagesResponse: Codable {
        public init (`messages`: [Message]?, `nextPageToken`: String?, `resultSizeEstimate`: Int?) {
            self.`messages` = `messages`
            self.`nextPageToken` = `nextPageToken`
            self.`resultSizeEstimate` = `resultSizeEstimate`
        }
        public var `messages`: [Message]?
        public var `nextPageToken`: String?
        public var `resultSizeEstimate`: Int?
    }

    public class ListSendAsResponse: Codable {
        public init (`sendAs`: [SendAs]?) {
            self.`sendAs` = `sendAs`
        }
        public var `sendAs`: [SendAs]?
    }

    public class ListSmimeInfoResponse: Codable {
        public init (`smimeInfo`: [SmimeInfo]?) {
            self.`smimeInfo` = `smimeInfo`
        }
        public var `smimeInfo`: [SmimeInfo]?
    }

    public class ListThreadsResponse: Codable {
        public init (`nextPageToken`: String?, `resultSizeEstimate`: Int?, `threads`: [Thread]?) {
            self.`nextPageToken` = `nextPageToken`
            self.`resultSizeEstimate` = `resultSizeEstimate`
            self.`threads` = `threads`
        }
        public var `nextPageToken`: String?
        public var `resultSizeEstimate`: Int?
        public var `threads`: [Thread]?
    }

    public class Message: Codable {
        public init (`historyId`: String?, `id`: String?, `internalDate`: String?, `labelIds`: [String]?, `payload`: MessagePart?, `raw`: String?, `sizeEstimate`: Int?, `snippet`: String?, `threadId`: String?) {
            self.`historyId` = `historyId`
            self.`id` = `id`
            self.`internalDate` = `internalDate`
            self.`labelIds` = `labelIds`
            self.`payload` = `payload`
            self.`raw` = `raw`
            self.`sizeEstimate` = `sizeEstimate`
            self.`snippet` = `snippet`
            self.`threadId` = `threadId`
        }
        public var `historyId`: String?
        public var `id`: String?
        public var `internalDate`: String?
        public var `labelIds`: [String]?
        public var `payload`: MessagePart?
        public var `raw`: String?
        public var `sizeEstimate`: Int?
        public var `snippet`: String?
        public var `threadId`: String?
    }

    public class MessagePart: Codable {
        public init (`body`: MessagePartBody?, `filename`: String?, `headers`: [MessagePartHeader]?, `mimeType`: String?, `partId`: String?, `parts`: [MessagePart]?) {
            self.`body` = `body`
            self.`filename` = `filename`
            self.`headers` = `headers`
            self.`mimeType` = `mimeType`
            self.`partId` = `partId`
            self.`parts` = `parts`
        }
        public var `body`: MessagePartBody?
        public var `filename`: String?
        public var `headers`: [MessagePartHeader]?
        public var `mimeType`: String?
        public var `partId`: String?
        public var `parts`: [MessagePart]?
    }

    public class MessagePartBody: Codable {
        public init (`attachmentId`: String?, `data`: String?, `size`: Int?) {
            self.`attachmentId` = `attachmentId`
            self.`data` = `data`
            self.`size` = `size`
        }
        public var `attachmentId`: String?
        public var `data`: String?
        public var `size`: Int?
    }

    public class MessagePartHeader: Codable {
        public init (`name`: String?, `value`: String?) {
            self.`name` = `name`
            self.`value` = `value`
        }
        public var `name`: String?
        public var `value`: String?
    }

    public class ModifyMessageRequest: Codable {
        public init (`addLabelIds`: [String]?, `removeLabelIds`: [String]?) {
            self.`addLabelIds` = `addLabelIds`
            self.`removeLabelIds` = `removeLabelIds`
        }
        public var `addLabelIds`: [String]?
        public var `removeLabelIds`: [String]?
    }

    public class ModifyThreadRequest: Codable {
        public init (`addLabelIds`: [String]?, `removeLabelIds`: [String]?) {
            self.`addLabelIds` = `addLabelIds`
            self.`removeLabelIds` = `removeLabelIds`
        }
        public var `addLabelIds`: [String]?
        public var `removeLabelIds`: [String]?
    }

    public class PopSettings: Codable {
        public init (`accessWindow`: String?, `disposition`: String?) {
            self.`accessWindow` = `accessWindow`
            self.`disposition` = `disposition`
        }
        public var `accessWindow`: String?
        public var `disposition`: String?
    }

    public class Profile: Codable {
        public init (`emailAddress`: String?, `historyId`: String?, `messagesTotal`: Int?, `threadsTotal`: Int?) {
            self.`emailAddress` = `emailAddress`
            self.`historyId` = `historyId`
            self.`messagesTotal` = `messagesTotal`
            self.`threadsTotal` = `threadsTotal`
        }
        public var `emailAddress`: String?
        public var `historyId`: String?
        public var `messagesTotal`: Int?
        public var `threadsTotal`: Int?
    }

    public class SendAs: Codable {
        public init (`displayName`: String?, `isDefault`: Bool?, `isPrimary`: Bool?, `replyToAddress`: String?, `sendAsEmail`: String?, `signature`: String?, `smtpMsa`: SmtpMsa?, `treatAsAlias`: Bool?, `verificationStatus`: String?) {
            self.`displayName` = `displayName`
            self.`isDefault` = `isDefault`
            self.`isPrimary` = `isPrimary`
            self.`replyToAddress` = `replyToAddress`
            self.`sendAsEmail` = `sendAsEmail`
            self.`signature` = `signature`
            self.`smtpMsa` = `smtpMsa`
            self.`treatAsAlias` = `treatAsAlias`
            self.`verificationStatus` = `verificationStatus`
        }
        public var `displayName`: String?
        public var `isDefault`: Bool?
        public var `isPrimary`: Bool?
        public var `replyToAddress`: String?
        public var `sendAsEmail`: String?
        public var `signature`: String?
        public var `smtpMsa`: SmtpMsa?
        public var `treatAsAlias`: Bool?
        public var `verificationStatus`: String?
    }

    public class SmimeInfo: Codable {
        public init (`encryptedKeyPassword`: String?, `expiration`: String?, `id`: String?, `isDefault`: Bool?, `issuerCn`: String?, `pem`: String?, `pkcs12`: String?) {
            self.`encryptedKeyPassword` = `encryptedKeyPassword`
            self.`expiration` = `expiration`
            self.`id` = `id`
            self.`isDefault` = `isDefault`
            self.`issuerCn` = `issuerCn`
            self.`pem` = `pem`
            self.`pkcs12` = `pkcs12`
        }
        public var `encryptedKeyPassword`: String?
        public var `expiration`: String?
        public var `id`: String?
        public var `isDefault`: Bool?
        public var `issuerCn`: String?
        public var `pem`: String?
        public var `pkcs12`: String?
    }

    public class SmtpMsa: Codable {
        public init (`host`: String?, `password`: String?, `port`: Int?, `securityMode`: String?, `username`: String?) {
            self.`host` = `host`
            self.`password` = `password`
            self.`port` = `port`
            self.`securityMode` = `securityMode`
            self.`username` = `username`
        }
        public var `host`: String?
        public var `password`: String?
        public var `port`: Int?
        public var `securityMode`: String?
        public var `username`: String?
    }

    public class Thread: Codable {
        public init (`historyId`: String?, `id`: String?, `messages`: [Message]?, `snippet`: String?) {
            self.`historyId` = `historyId`
            self.`id` = `id`
            self.`messages` = `messages`
            self.`snippet` = `snippet`
        }
        public var `historyId`: String?
        public var `id`: String?
        public var `messages`: [Message]?
        public var `snippet`: String?
    }

    public class VacationSettings: Codable {
        public init (`enableAutoReply`: Bool?, `endTime`: String?, `responseBodyHtml`: String?, `responseBodyPlainText`: String?, `responseSubject`: String?, `restrictToContacts`: Bool?, `restrictToDomain`: Bool?, `startTime`: String?) {
            self.`enableAutoReply` = `enableAutoReply`
            self.`endTime` = `endTime`
            self.`responseBodyHtml` = `responseBodyHtml`
            self.`responseBodyPlainText` = `responseBodyPlainText`
            self.`responseSubject` = `responseSubject`
            self.`restrictToContacts` = `restrictToContacts`
            self.`restrictToDomain` = `restrictToDomain`
            self.`startTime` = `startTime`
        }
        public var `enableAutoReply`: Bool?
        public var `endTime`: String?
        public var `responseBodyHtml`: String?
        public var `responseBodyPlainText`: String?
        public var `responseSubject`: String?
        public var `restrictToContacts`: Bool?
        public var `restrictToDomain`: Bool?
        public var `startTime`: String?
    }

    public class WatchRequest: Codable {
        public init (`labelFilterAction`: String?, `labelIds`: [String]?, `topicName`: String?) {
            self.`labelFilterAction` = `labelFilterAction`
            self.`labelIds` = `labelIds`
            self.`topicName` = `topicName`
        }
        public var `labelFilterAction`: String?
        public var `labelIds`: [String]?
        public var `topicName`: String?
    }

    public class WatchResponse: Codable {
        public init (`expiration`: String?, `historyId`: String?) {
            self.`expiration` = `expiration`
            self.`historyId` = `historyId`
        }
        public var `expiration`: String?
        public var `historyId`: String?
    }




    public class usersgetProfileParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_getProfile (
        parameters: usersgetProfileParameters,
        completion: @escaping (Profile?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/profile",
                parameters: parameters,
                completion: completion)
    }


    public class usersstopParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_stop (
        parameters: usersstopParameters,
        completion: @escaping (Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/stop",
                parameters: parameters,
                completion: completion)
    }


    public class userswatchParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_watch (
        request: WatchRequest,
        parameters: userswatchParameters,
        completion: @escaping (WatchResponse?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/watch",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_draftscreateParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_drafts_create (
        request: Draft,
        parameters: users_draftscreateParameters,
        completion: @escaping (Draft?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/drafts",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_draftsdeleteParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_drafts_delete (
        parameters: users_draftsdeleteParameters,
        completion: @escaping (Error?) -> ()) throws {
            try perform(
                method: "DELETE",
                path: "gmail/v1/users/{userId}/drafts/{id}",
                parameters: parameters,
                completion: completion)
    }


    public class users_draftsgetParameters: Parameterizable {
        public init (`format`: String?, `id`: String?, `userId`: String?) {
            self.`format` = `format`
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `format`: String?
        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            ["format"]
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_drafts_get (
        parameters: users_draftsgetParameters,
        completion: @escaping (Draft?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/drafts/{id}",
                parameters: parameters,
                completion: completion)
    }


    public class users_draftslistParameters: Parameterizable {
        public init (`includeSpamTrash`: Bool?, `maxResults`: Int?, `pageToken`: String?, `q`: String?, `userId`: String?) {
            self.`includeSpamTrash` = `includeSpamTrash`
            self.`maxResults` = `maxResults`
            self.`pageToken` = `pageToken`
            self.`q` = `q`
            self.`userId` = `userId`
        }

        public var `includeSpamTrash`: Bool?
        public var `maxResults`: Int?
        public var `pageToken`: String?
        public var `q`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            ["includeSpamTrash","maxResults","pageToken","q"]
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_drafts_list (
        parameters: users_draftslistParameters,
        completion: @escaping (ListDraftsResponse?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/drafts",
                parameters: parameters,
                completion: completion)
    }


    public class users_draftssendParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_drafts_send (
        request: Draft,
        parameters: users_draftssendParameters,
        completion: @escaping (Message?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/drafts/send",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_draftsupdateParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_drafts_update (
        request: Draft,
        parameters: users_draftsupdateParameters,
        completion: @escaping (Draft?, Error?) -> ()) throws {
            try perform(
                method: "PUT",
                path: "gmail/v1/users/{userId}/drafts/{id}",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_historylistParameters: Parameterizable {
        public init (`historyTypes`: String?, `labelId`: String?, `maxResults`: Int?, `pageToken`: String?, `startHistoryId`: String?, `userId`: String?) {
            self.`historyTypes` = `historyTypes`
            self.`labelId` = `labelId`
            self.`maxResults` = `maxResults`
            self.`pageToken` = `pageToken`
            self.`startHistoryId` = `startHistoryId`
            self.`userId` = `userId`
        }

        public var `historyTypes`: String?
        public var `labelId`: String?
        public var `maxResults`: Int?
        public var `pageToken`: String?
        public var `startHistoryId`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            ["historyTypes","labelId","maxResults","pageToken","startHistoryId"]
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_history_list (
        parameters: users_historylistParameters,
        completion: @escaping (ListHistoryResponse?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/history",
                parameters: parameters,
                completion: completion)
    }


    public class users_labelscreateParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_labels_create (
        request: Label,
        parameters: users_labelscreateParameters,
        completion: @escaping (Label?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/labels",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_labelsdeleteParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_labels_delete (
        parameters: users_labelsdeleteParameters,
        completion: @escaping (Error?) -> ()) throws {
            try perform(
                method: "DELETE",
                path: "gmail/v1/users/{userId}/labels/{id}",
                parameters: parameters,
                completion: completion)
    }


    public class users_labelsgetParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_labels_get (
        parameters: users_labelsgetParameters,
        completion: @escaping (Label?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/labels/{id}",
                parameters: parameters,
                completion: completion)
    }


    public class users_labelslistParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_labels_list (
        parameters: users_labelslistParameters,
        completion: @escaping (ListLabelsResponse?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/labels",
                parameters: parameters,
                completion: completion)
    }


    public class users_labelspatchParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_labels_patch (
        request: Label,
        parameters: users_labelspatchParameters,
        completion: @escaping (Label?, Error?) -> ()) throws {
            try perform(
                method: "PATCH",
                path: "gmail/v1/users/{userId}/labels/{id}",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_labelsupdateParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_labels_update (
        request: Label,
        parameters: users_labelsupdateParameters,
        completion: @escaping (Label?, Error?) -> ()) throws {
            try perform(
                method: "PUT",
                path: "gmail/v1/users/{userId}/labels/{id}",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_messagesbatchDeleteParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_messages_batchDelete (
        request: BatchDeleteMessagesRequest,
        parameters: users_messagesbatchDeleteParameters,
        completion: @escaping (Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/messages/batchDelete",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_messagesbatchModifyParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_messages_batchModify (
        request: BatchModifyMessagesRequest,
        parameters: users_messagesbatchModifyParameters,
        completion: @escaping (Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/messages/batchModify",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_messagesdeleteParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_messages_delete (
        parameters: users_messagesdeleteParameters,
        completion: @escaping (Error?) -> ()) throws {
            try perform(
                method: "DELETE",
                path: "gmail/v1/users/{userId}/messages/{id}",
                parameters: parameters,
                completion: completion)
    }


    public class users_messagesgetParameters: Parameterizable {
        public init (`format`: String?, `id`: String?, `metadataHeaders`: String?, `userId`: String?) {
            self.`format` = `format`
            self.`id` = `id`
            self.`metadataHeaders` = `metadataHeaders`
            self.`userId` = `userId`
        }

        public var `format`: String?
        public var `id`: String?
        public var `metadataHeaders`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            ["format","metadataHeaders"]
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_messages_get (
        parameters: users_messagesgetParameters,
        completion: @escaping (Message?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/messages/{id}",
                parameters: parameters,
                completion: completion)
    }


    public class users_messagesimportParameters: Parameterizable {
        public init (`deleted`: Bool?, `internalDateSource`: String?, `neverMarkSpam`: Bool?, `processForCalendar`: Bool?, `userId`: String?) {
            self.`deleted` = `deleted`
            self.`internalDateSource` = `internalDateSource`
            self.`neverMarkSpam` = `neverMarkSpam`
            self.`processForCalendar` = `processForCalendar`
            self.`userId` = `userId`
        }

        public var `deleted`: Bool?
        public var `internalDateSource`: String?
        public var `neverMarkSpam`: Bool?
        public var `processForCalendar`: Bool?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            ["deleted","internalDateSource","neverMarkSpam","processForCalendar"]
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_messages_import (
        request: Message,
        parameters: users_messagesimportParameters,
        completion: @escaping (Message?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/messages/import",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_messagesinsertParameters: Parameterizable {
        public init (`deleted`: Bool?, `internalDateSource`: String?, `userId`: String?) {
            self.`deleted` = `deleted`
            self.`internalDateSource` = `internalDateSource`
            self.`userId` = `userId`
        }

        public var `deleted`: Bool?
        public var `internalDateSource`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            ["deleted","internalDateSource"]
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_messages_insert (
        request: Message,
        parameters: users_messagesinsertParameters,
        completion: @escaping (Message?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/messages",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_messageslistParameters: Parameterizable {
        public init (`includeSpamTrash`: Bool?, `labelIds`: String?, `maxResults`: Int?, `pageToken`: String?, `q`: String?, `userId`: String?) {
            self.`includeSpamTrash` = `includeSpamTrash`
            self.`labelIds` = `labelIds`
            self.`maxResults` = `maxResults`
            self.`pageToken` = `pageToken`
            self.`q` = `q`
            self.`userId` = `userId`
        }

        public var `includeSpamTrash`: Bool?
        public var `labelIds`: String?
        public var `maxResults`: Int?
        public var `pageToken`: String?
        public var `q`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            ["includeSpamTrash","labelIds","maxResults","pageToken","q"]
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_messages_list (
        parameters: users_messageslistParameters,
        completion: @escaping (ListMessagesResponse?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/messages",
                parameters: parameters,
                completion: completion)
    }


    public class users_messagesmodifyParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_messages_modify (
        request: ModifyMessageRequest,
        parameters: users_messagesmodifyParameters,
        completion: @escaping (Message?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/messages/{id}/modify",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_messagessendParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_messages_send (
        request: Message,
        parameters: users_messagessendParameters,
        completion: @escaping (Message?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/messages/send",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_messagestrashParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_messages_trash (
        parameters: users_messagestrashParameters,
        completion: @escaping (Message?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/messages/{id}/trash",
                parameters: parameters,
                completion: completion)
    }


    public class users_messagesuntrashParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_messages_untrash (
        parameters: users_messagesuntrashParameters,
        completion: @escaping (Message?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/messages/{id}/untrash",
                parameters: parameters,
                completion: completion)
    }


    public class users_messages_attachmentsgetParameters: Parameterizable {
        public init (`id`: String?, `messageId`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`messageId` = `messageId`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `messageId`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","messageId","userId"]
        }
    }

    public func users_messages_attachments_get (
        parameters: users_messages_attachmentsgetParameters,
        completion: @escaping (MessagePartBody?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/messages/{messageId}/attachments/{id}",
                parameters: parameters,
                completion: completion)
    }


    public class users_settingsgetAutoForwardingParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_getAutoForwarding (
        parameters: users_settingsgetAutoForwardingParameters,
        completion: @escaping (AutoForwarding?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/autoForwarding",
                parameters: parameters,
                completion: completion)
    }


    public class users_settingsgetImapParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_getImap (
        parameters: users_settingsgetImapParameters,
        completion: @escaping (ImapSettings?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/imap",
                parameters: parameters,
                completion: completion)
    }


    public class users_settingsgetLanguageParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_getLanguage (
        parameters: users_settingsgetLanguageParameters,
        completion: @escaping (LanguageSettings?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/language",
                parameters: parameters,
                completion: completion)
    }


    public class users_settingsgetPopParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_getPop (
        parameters: users_settingsgetPopParameters,
        completion: @escaping (PopSettings?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/pop",
                parameters: parameters,
                completion: completion)
    }


    public class users_settingsgetVacationParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_getVacation (
        parameters: users_settingsgetVacationParameters,
        completion: @escaping (VacationSettings?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/vacation",
                parameters: parameters,
                completion: completion)
    }


    public class users_settingsupdateAutoForwardingParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_updateAutoForwarding (
        request: AutoForwarding,
        parameters: users_settingsupdateAutoForwardingParameters,
        completion: @escaping (AutoForwarding?, Error?) -> ()) throws {
            try perform(
                method: "PUT",
                path: "gmail/v1/users/{userId}/settings/autoForwarding",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_settingsupdateImapParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_updateImap (
        request: ImapSettings,
        parameters: users_settingsupdateImapParameters,
        completion: @escaping (ImapSettings?, Error?) -> ()) throws {
            try perform(
                method: "PUT",
                path: "gmail/v1/users/{userId}/settings/imap",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_settingsupdateLanguageParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_updateLanguage (
        request: LanguageSettings,
        parameters: users_settingsupdateLanguageParameters,
        completion: @escaping (LanguageSettings?, Error?) -> ()) throws {
            try perform(
                method: "PUT",
                path: "gmail/v1/users/{userId}/settings/language",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_settingsupdatePopParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_updatePop (
        request: PopSettings,
        parameters: users_settingsupdatePopParameters,
        completion: @escaping (PopSettings?, Error?) -> ()) throws {
            try perform(
                method: "PUT",
                path: "gmail/v1/users/{userId}/settings/pop",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_settingsupdateVacationParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_updateVacation (
        request: VacationSettings,
        parameters: users_settingsupdateVacationParameters,
        completion: @escaping (VacationSettings?, Error?) -> ()) throws {
            try perform(
                method: "PUT",
                path: "gmail/v1/users/{userId}/settings/vacation",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_delegatescreateParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_delegates_create (
        request: Delegate,
        parameters: users_settings_delegatescreateParameters,
        completion: @escaping (Delegate?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/settings/delegates",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_delegatesdeleteParameters: Parameterizable {
        public init (`delegateEmail`: String?, `userId`: String?) {
            self.`delegateEmail` = `delegateEmail`
            self.`userId` = `userId`
        }

        public var `delegateEmail`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["delegateEmail","userId"]
        }
    }

    public func users_settings_delegates_delete (
        parameters: users_settings_delegatesdeleteParameters,
        completion: @escaping (Error?) -> ()) throws {
            try perform(
                method: "DELETE",
                path: "gmail/v1/users/{userId}/settings/delegates/{delegateEmail}",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_delegatesgetParameters: Parameterizable {
        public init (`delegateEmail`: String?, `userId`: String?) {
            self.`delegateEmail` = `delegateEmail`
            self.`userId` = `userId`
        }

        public var `delegateEmail`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["delegateEmail","userId"]
        }
    }

    public func users_settings_delegates_get (
        parameters: users_settings_delegatesgetParameters,
        completion: @escaping (Delegate?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/delegates/{delegateEmail}",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_delegateslistParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_delegates_list (
        parameters: users_settings_delegateslistParameters,
        completion: @escaping (ListDelegatesResponse?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/delegates",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_filterscreateParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_filters_create (
        request: Filter,
        parameters: users_settings_filterscreateParameters,
        completion: @escaping (Filter?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/settings/filters",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_filtersdeleteParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_settings_filters_delete (
        parameters: users_settings_filtersdeleteParameters,
        completion: @escaping (Error?) -> ()) throws {
            try perform(
                method: "DELETE",
                path: "gmail/v1/users/{userId}/settings/filters/{id}",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_filtersgetParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_settings_filters_get (
        parameters: users_settings_filtersgetParameters,
        completion: @escaping (Filter?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/filters/{id}",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_filterslistParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_filters_list (
        parameters: users_settings_filterslistParameters,
        completion: @escaping (ListFiltersResponse?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/filters",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_forwardingAddressescreateParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_forwardingAddresses_create (
        request: ForwardingAddress,
        parameters: users_settings_forwardingAddressescreateParameters,
        completion: @escaping (ForwardingAddress?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/settings/forwardingAddresses",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_forwardingAddressesdeleteParameters: Parameterizable {
        public init (`forwardingEmail`: String?, `userId`: String?) {
            self.`forwardingEmail` = `forwardingEmail`
            self.`userId` = `userId`
        }

        public var `forwardingEmail`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["forwardingEmail","userId"]
        }
    }

    public func users_settings_forwardingAddresses_delete (
        parameters: users_settings_forwardingAddressesdeleteParameters,
        completion: @escaping (Error?) -> ()) throws {
            try perform(
                method: "DELETE",
                path: "gmail/v1/users/{userId}/settings/forwardingAddresses/{forwardingEmail}",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_forwardingAddressesgetParameters: Parameterizable {
        public init (`forwardingEmail`: String?, `userId`: String?) {
            self.`forwardingEmail` = `forwardingEmail`
            self.`userId` = `userId`
        }

        public var `forwardingEmail`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["forwardingEmail","userId"]
        }
    }

    public func users_settings_forwardingAddresses_get (
        parameters: users_settings_forwardingAddressesgetParameters,
        completion: @escaping (ForwardingAddress?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/forwardingAddresses/{forwardingEmail}",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_forwardingAddresseslistParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_forwardingAddresses_list (
        parameters: users_settings_forwardingAddresseslistParameters,
        completion: @escaping (ListForwardingAddressesResponse?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/forwardingAddresses",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_sendAscreateParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_sendAs_create (
        request: SendAs,
        parameters: users_settings_sendAscreateParameters,
        completion: @escaping (SendAs?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/settings/sendAs",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_sendAsdeleteParameters: Parameterizable {
        public init (`sendAsEmail`: String?, `userId`: String?) {
            self.`sendAsEmail` = `sendAsEmail`
            self.`userId` = `userId`
        }

        public var `sendAsEmail`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["sendAsEmail","userId"]
        }
    }

    public func users_settings_sendAs_delete (
        parameters: users_settings_sendAsdeleteParameters,
        completion: @escaping (Error?) -> ()) throws {
            try perform(
                method: "DELETE",
                path: "gmail/v1/users/{userId}/settings/sendAs/{sendAsEmail}",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_sendAsgetParameters: Parameterizable {
        public init (`sendAsEmail`: String?, `userId`: String?) {
            self.`sendAsEmail` = `sendAsEmail`
            self.`userId` = `userId`
        }

        public var `sendAsEmail`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["sendAsEmail","userId"]
        }
    }

    public func users_settings_sendAs_get (
        parameters: users_settings_sendAsgetParameters,
        completion: @escaping (SendAs?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/sendAs/{sendAsEmail}",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_sendAslistParameters: Parameterizable {
        public init (`userId`: String?) {
            self.`userId` = `userId`
        }

        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_settings_sendAs_list (
        parameters: users_settings_sendAslistParameters,
        completion: @escaping (ListSendAsResponse?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/sendAs",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_sendAspatchParameters: Parameterizable {
        public init (`sendAsEmail`: String?, `userId`: String?) {
            self.`sendAsEmail` = `sendAsEmail`
            self.`userId` = `userId`
        }

        public var `sendAsEmail`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["sendAsEmail","userId"]
        }
    }

    public func users_settings_sendAs_patch (
        request: SendAs,
        parameters: users_settings_sendAspatchParameters,
        completion: @escaping (SendAs?, Error?) -> ()) throws {
            try perform(
                method: "PATCH",
                path: "gmail/v1/users/{userId}/settings/sendAs/{sendAsEmail}",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_sendAsupdateParameters: Parameterizable {
        public init (`sendAsEmail`: String?, `userId`: String?) {
            self.`sendAsEmail` = `sendAsEmail`
            self.`userId` = `userId`
        }

        public var `sendAsEmail`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["sendAsEmail","userId"]
        }
    }

    public func users_settings_sendAs_update (
        request: SendAs,
        parameters: users_settings_sendAsupdateParameters,
        completion: @escaping (SendAs?, Error?) -> ()) throws {
            try perform(
                method: "PUT",
                path: "gmail/v1/users/{userId}/settings/sendAs/{sendAsEmail}",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_sendAsverifyParameters: Parameterizable {
        public init (`sendAsEmail`: String?, `userId`: String?) {
            self.`sendAsEmail` = `sendAsEmail`
            self.`userId` = `userId`
        }

        public var `sendAsEmail`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["sendAsEmail","userId"]
        }
    }

    public func users_settings_sendAs_verify (
        parameters: users_settings_sendAsverifyParameters,
        completion: @escaping (Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/settings/sendAs/{sendAsEmail}/verify",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_sendAs_smimeInfodeleteParameters: Parameterizable {
        public init (`id`: String?, `sendAsEmail`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`sendAsEmail` = `sendAsEmail`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `sendAsEmail`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","sendAsEmail","userId"]
        }
    }

    public func users_settings_sendAs_smimeInfo_delete (
        parameters: users_settings_sendAs_smimeInfodeleteParameters,
        completion: @escaping (Error?) -> ()) throws {
            try perform(
                method: "DELETE",
                path: "gmail/v1/users/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_sendAs_smimeInfogetParameters: Parameterizable {
        public init (`id`: String?, `sendAsEmail`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`sendAsEmail` = `sendAsEmail`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `sendAsEmail`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","sendAsEmail","userId"]
        }
    }

    public func users_settings_sendAs_smimeInfo_get (
        parameters: users_settings_sendAs_smimeInfogetParameters,
        completion: @escaping (SmimeInfo?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_sendAs_smimeInfoinsertParameters: Parameterizable {
        public init (`sendAsEmail`: String?, `userId`: String?) {
            self.`sendAsEmail` = `sendAsEmail`
            self.`userId` = `userId`
        }

        public var `sendAsEmail`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["sendAsEmail","userId"]
        }
    }

    public func users_settings_sendAs_smimeInfo_insert (
        request: SmimeInfo,
        parameters: users_settings_sendAs_smimeInfoinsertParameters,
        completion: @escaping (SmimeInfo?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_sendAs_smimeInfolistParameters: Parameterizable {
        public init (`sendAsEmail`: String?, `userId`: String?) {
            self.`sendAsEmail` = `sendAsEmail`
            self.`userId` = `userId`
        }

        public var `sendAsEmail`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["sendAsEmail","userId"]
        }
    }

    public func users_settings_sendAs_smimeInfo_list (
        parameters: users_settings_sendAs_smimeInfolistParameters,
        completion: @escaping (ListSmimeInfoResponse?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo",
                parameters: parameters,
                completion: completion)
    }


    public class users_settings_sendAs_smimeInfosetDefaultParameters: Parameterizable {
        public init (`id`: String?, `sendAsEmail`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`sendAsEmail` = `sendAsEmail`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `sendAsEmail`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","sendAsEmail","userId"]
        }
    }

    public func users_settings_sendAs_smimeInfo_setDefault (
        parameters: users_settings_sendAs_smimeInfosetDefaultParameters,
        completion: @escaping (Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/settings/sendAs/{sendAsEmail}/smimeInfo/{id}/setDefault",
                parameters: parameters,
                completion: completion)
    }


    public class users_threadsdeleteParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_threads_delete (
        parameters: users_threadsdeleteParameters,
        completion: @escaping (Error?) -> ()) throws {
            try perform(
                method: "DELETE",
                path: "gmail/v1/users/{userId}/threads/{id}",
                parameters: parameters,
                completion: completion)
    }


    public class users_threadsgetParameters: Parameterizable {
        public init (`format`: String?, `id`: String?, `metadataHeaders`: String?, `userId`: String?) {
            self.`format` = `format`
            self.`id` = `id`
            self.`metadataHeaders` = `metadataHeaders`
            self.`userId` = `userId`
        }

        public var `format`: String?
        public var `id`: String?
        public var `metadataHeaders`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            ["format","metadataHeaders"]
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_threads_get (
        parameters: users_threadsgetParameters,
        completion: @escaping (Thread?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/threads/{id}",
                parameters: parameters,
                completion: completion)
    }


    public class users_threadslistParameters: Parameterizable {
        public init (`includeSpamTrash`: Bool?, `labelIds`: String?, `maxResults`: Int?, `pageToken`: String?, `q`: String?, `userId`: String?) {
            self.`includeSpamTrash` = `includeSpamTrash`
            self.`labelIds` = `labelIds`
            self.`maxResults` = `maxResults`
            self.`pageToken` = `pageToken`
            self.`q` = `q`
            self.`userId` = `userId`
        }

        public var `includeSpamTrash`: Bool?
        public var `labelIds`: String?
        public var `maxResults`: Int?
        public var `pageToken`: String?
        public var `q`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            ["includeSpamTrash","labelIds","maxResults","pageToken","q"]
        }
        public func pathParameters() -> [String] {
            ["userId"]
        }
    }

    public func users_threads_list (
        parameters: users_threadslistParameters,
        completion: @escaping (ListThreadsResponse?, Error?) -> ()) throws {
            try perform(
                method: "GET",
                path: "gmail/v1/users/{userId}/threads",
                parameters: parameters,
                completion: completion)
    }


    public class users_threadsmodifyParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_threads_modify (
        request: ModifyThreadRequest,
        parameters: users_threadsmodifyParameters,
        completion: @escaping (Thread?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/threads/{id}/modify",
                request: request,
                parameters: parameters,
                completion: completion)
    }


    public class users_threadstrashParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_threads_trash (
        parameters: users_threadstrashParameters,
        completion: @escaping (Thread?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/threads/{id}/trash",
                parameters: parameters,
                completion: completion)
    }


    public class users_threadsuntrashParameters: Parameterizable {
        public init (`id`: String?, `userId`: String?) {
            self.`id` = `id`
            self.`userId` = `userId`
        }

        public var `id`: String?
        public var `userId`: String?

        public func queryParameters() -> [String] {
            []
        }
        public func pathParameters() -> [String] {
            ["id","userId"]
        }
    }

    public func users_threads_untrash (
        parameters: users_threadsuntrashParameters,
        completion: @escaping (Thread?, Error?) -> ()) throws {
            try perform(
                method: "POST",
                path: "gmail/v1/users/{userId}/threads/{id}/untrash",
                parameters: parameters,
                completion: completion)
    }


}
