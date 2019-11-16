//
//  BitService+BBAPIKeyInfo.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {
    /// A type that represents the API Key information for the Bybit account.
    struct BybitAPIKeyInfo {
        
        /// The API key for the Bybit account.
        let apiKey: String
        
        /// The user ID for the Bybit account.
        let userID: Int

        /// Associated IP addresses permitted to access Bybit.
        let ipAddresses: [String]

        /// Unique information about the account - currently returns the account holder's name.
        let note: String

        /// Actions the Bybit account is allowed to take.
        let permissions: [String]

        /// The time the Bybit account was created.
        let timeCreated: String

        /// The read only flag.
        let isReadOnly: Bool
        
        /// Server data about the response.
        let metaData: BitService.BybitResponseMetaData
    }
}

extension BitService.BybitAPIKeyInfo: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case result
    }
    
    private enum ResultKeys: String, CodingKey {
        case apiKey = "api_key"
        case userID = "user_id"
        case ipAddresses = "ips"
        case note
        case permissions
        case timeCreated = "created_at"
        case isReadOnly = "read_only"
    }
    
    public init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        self.metaData = try BitService.BybitResponseMetaData(from: decoder)

        var array = try results.nestedUnkeyedContainer(forKey: .result)
        let data = try array.nestedContainer(keyedBy: ResultKeys.self)

        self.apiKey = try data.decode(String.self, forKey: .apiKey)
        self.userID = try data.decode(Int.self, forKey: .userID)
        self.ipAddresses = try data.decode(Array.self, forKey: .ipAddresses)
        self.note = try data.decode(String.self, forKey: .note)
        self.permissions = try data.decode(Array.self, forKey: .permissions)
        self.timeCreated = try data.decode(String.self, forKey: .timeCreated)
        self.isReadOnly = try data.decode(Bool.self, forKey: .isReadOnly)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ResultKeys.self)

        try container.encode(apiKey, forKey: .apiKey)
        try container.encode(userID, forKey: .userID)
        try container.encode(ipAddresses, forKey: .ipAddresses)
        try container.encode(note, forKey: .note)
        try container.encode(permissions, forKey: .permissions)
        try container.encode(timeCreated, forKey: .timeCreated)
        try container.encode(isReadOnly, forKey: .isReadOnly)
    }
}
