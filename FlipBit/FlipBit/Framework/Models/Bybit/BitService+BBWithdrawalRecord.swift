//
//  BitService+BBWithdrawalRecord.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/12/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {
    struct BybitWithdrawalRecords {
        
        /// An array of WithdrawalEvents.
        let records: [BitService.BybitWithdrawalEvent]
        
        /// The current page of records returned.
        let currentPage: Int
        
        /// The last page.
        let lastPage: Int
        
        /// Server data about the response.
        let metaData: BitService.BybitResponseMetaData
    }
}

extension BitService.BybitWithdrawalRecords: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case result
        case data
        case currentPage = "current_page"
        case lastPage = "last_page"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.metaData = try BitService.BybitResponseMetaData(from: decoder)
        
        let dictionary = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        self.records = try dictionary.decode([BitService.BybitWithdrawalEvent].self, forKey: .data)
        self.currentPage = try dictionary.decode(Int.self, forKey: .currentPage)
        self.lastPage = try dictionary.decode(Int.self, forKey: .lastPage)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(records, forKey: .data)
    }
}

public extension BitService {
    /// A type that represents a wallet withdrawal event.
    struct BybitWithdrawalEvent {
        
        /// The funding event ID.
        let eventID: Int
        
        /// The user ID.
        let userID: Int
        
        /// The currency of the funding event.
        let currency: BitService.Currency
        
        /// The status of the funding event.
        let status: BitService.BybitWithdrawalStatus
        
        /// The amount withdrawn.
        let amount: String
        
        /// The withdrawal fee.
        let fee: String
        
        /// The destination address of the withdrawal.
        let address: String
        
        /// The transaction ID.
        let transactionID: String
        
        /// The time the withdrawal event was initiated.
        let timeSubmitted: String
        
        /// The time the withdrawal event was updated.
        let timeUpdated: String
    }
}

extension BitService.BybitWithdrawalEvent: Model {
    /// List of top level coding keys.
    enum CodingKeys: String, CodingKey {
        case eventID = "id"
        case userID = "user_id"
        case currency = "coin"
        case status
        case amount
        case fee
        case address
        case transactionID = "tx_id"
        case timeSubmitted = "submitted_at"
        case timeUpdated = "updated_at"
    }
    
    public init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        self.eventID = try results.decode(Int.self, forKey: .eventID)
        self.userID = try results.decode(Int.self, forKey: .userID)
        self.currency = try results.decode(BitService.Currency.self, forKey: .currency)
        self.status = try results.decode(BitService.BybitWithdrawalStatus.self, forKey: .status)
        self.amount = try results.decode(String.self, forKey: .amount)
        self.fee = try results.decode(String.self, forKey: .fee)
        self.address = try results.decode(String.self, forKey: .address)
        self.transactionID = try results.decode(String.self, forKey: .transactionID)
        self.timeSubmitted = try results.decode(String.self, forKey: .timeSubmitted)
        self.timeUpdated = try results.decode(String.self, forKey: .timeUpdated)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(eventID, forKey: .eventID)
        try container.encode(userID, forKey: .userID)
        try container.encode(currency, forKey: .currency)
        try container.encode(status, forKey: .status)
        try container.encode(amount, forKey: .amount)
        try container.encode(fee, forKey: .fee)
        try container.encode(address, forKey: .address)
        try container.encode(transactionID, forKey: .transactionID)
        try container.encode(timeSubmitted, forKey: .timeSubmitted)
        try container.encode(timeUpdated, forKey: .timeUpdated)
    }
}
