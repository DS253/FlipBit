//
//  BitService+BBResponseMetaData.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/16/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {
    struct BybitResponseMetaData {
        
        /// The Bybit-specific return code: 0 is success, otherwise failure.
        let returnCode: Int?
        
        /// Message returns `ok` on success, a detailed description for a failure.
        let returnMessage: String?
        
        /// External Code Errorl
        let externalCodeError: String?
        
        /// Exit information.
        let exitInfo: String?
        
        /// The time of the response.
        let timeNow: String?
    }
}

extension BitService.BybitResponseMetaData: Model {
    /// List of top level coding keys.
    enum CodingKeys: String, CodingKey {
        case externalError = "ext_code"
        case info = "ext_info"
        case message = "ret_msg"
        case returnCode = "ret_code"
        case time = "time_now"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.returnCode = try values.decodeIfPresent(Int.self, forKey: .returnCode)
        self.returnMessage = try values.decodeIfPresent(String.self, forKey: .message)
        self.externalCodeError = try values.decodeIfPresent(String.self, forKey: .externalError)
        self.exitInfo = try values.decodeIfPresent(String.self, forKey: .info)
        self.timeNow = try values.decodeIfPresent(String.self, forKey: .time)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(returnCode, forKey: .returnCode)
        try container.encodeIfPresent(returnMessage, forKey: .message)
        try container.encodeIfPresent(externalCodeError, forKey: .externalError)
        try container.encodeIfPresent(exitInfo, forKey: .info)
        try container.encodeIfPresent(timeNow, forKey: .time)
    }
    
    func success() -> Bool {
        return returnCode == 0
    }
}
