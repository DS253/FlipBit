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
        
        /// The limit on number of calls to Bybit's API.
        let rateLimit: Int?
        
        /// The remaining number of calls before reaching the rate limit.
        let rateLimitStatus: Int?
        
        /// The amount of time before the rate limit is reset.
        let rateLimitResetTime: Int?
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
        case rateLimit = "rate_limit"
        case rateLimitStatus = "rate_limit_status"
        case rateLimitResetTime = "rate_limit_reset_ms"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.returnCode = try values.decodeIfPresent(Int.self, forKey: .returnCode)
        self.returnMessage = try values.decodeIfPresent(String.self, forKey: .message)
        self.externalCodeError = try values.decodeIfPresent(String.self, forKey: .externalError)
        self.exitInfo = try values.decodeIfPresent(String.self, forKey: .info)
        self.timeNow = try values.decodeIfPresent(String.self, forKey: .time)
        self.rateLimit = try values.decodeIfPresent(Int.self, forKey: .rateLimit)
        self.rateLimitStatus = try values.decodeIfPresent(Int.self, forKey: .rateLimitStatus)
        self.rateLimitResetTime = try values.decodeIfPresent(Int.self, forKey: .rateLimitResetTime)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(returnCode, forKey: .returnCode)
        try container.encodeIfPresent(returnMessage, forKey: .message)
        try container.encodeIfPresent(externalCodeError, forKey: .externalError)
        try container.encodeIfPresent(exitInfo, forKey: .info)
        try container.encodeIfPresent(timeNow, forKey: .time)
        try container.encodeIfPresent(rateLimit, forKey: .rateLimit)
        try container.encodeIfPresent(rateLimitStatus, forKey: .rateLimitStatus)
        try container.encodeIfPresent(rateLimitResetTime, forKey: .rateLimitResetTime)
    }
    
    func success() -> Bool {
        return returnCode == 0
    }
}
