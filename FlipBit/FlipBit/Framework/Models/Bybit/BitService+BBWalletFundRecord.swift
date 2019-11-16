//
//  BitService+BBWalletFundRecord.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/12/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {
    /// A type that represents a wallet funding event.
    struct BybitWalletFundingEvent {
        
        /// The funding event ID.
        let eventID: Int
        
        /// The user ID.
        let userID: Int
        
        /// The currency of the funding event.
        let currency: BitService.Currency
        
        /// The type of funding event.
        let type: BitService.BybitFundingEvent
        
        /// The amount of the funding event.
        let amount: String
        
        /// The transaction ID.
        let transactionID: String
        
        /// The wallet address.
        let address: String
        
        /// The wallet balance after the funding event.
        let balance: String
        
        /// The time of the funding event.
        let timeOfEvent: String
    }
}

extension BitService.BybitWalletFundingEvent: Model {
    /// List of top level coding keys.
    enum CodingKeys: String, CodingKey {
        case eventID = "id"
        case userID = "user_id"
        case currency = "coin"
        case type
        case amount
        case transactionID = "tx_id"
        case address
        case balance = "wallet_balance"
        case timeOfEvent = "exec_time"
    }
    
    public init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        self.eventID = try results.decode(Int.self, forKey: .eventID)
        self.userID = try results.decode(Int.self, forKey: .userID)
        self.currency = try results.decode(BitService.Currency.self, forKey: .currency)
        self.type = try results.decode(BitService.BybitFundingEvent.self, forKey: .type)
        self.amount = try results.decode(String.self, forKey: .amount)
        self.transactionID = try results.decode(String.self, forKey: .transactionID)
        self.address = try results.decode(String.self, forKey: .address)
        self.balance = try results.decode(String.self, forKey: .balance)
        self.timeOfEvent = try results.decode(String.self, forKey: .timeOfEvent)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(eventID, forKey: .eventID)
        try container.encode(userID, forKey: .userID)
        try container.encode(currency, forKey: .currency)
        try container.encode(type, forKey: .type)
        try container.encode(amount, forKey: .amount)
        try container.encode(transactionID, forKey: .transactionID)
        try container.encode(address, forKey: .address)
        try container.encode(balance, forKey: .balance)
        try container.encode(timeOfEvent, forKey: .timeOfEvent)
    }
}

public extension BitService {
    struct BybitWalletRecords {

        /// Array of WalletFundingEvents
        let records: [BitService.BybitWalletFundingEvent]?

        /// Server data about the response.
        let metaData: BitService.BybitResponseMetaData
    }
}

extension BitService.BybitWalletRecords: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case result
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.metaData = try BitService.BybitResponseMetaData(from: decoder)
        
        let dictionary = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        self.records = try dictionary.decodeIfPresent([BitService.BybitWalletFundingEvent].self, forKey: .data)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(records, forKey: .data)
    }
}
