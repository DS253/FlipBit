//
//  BitService+BBServerTime.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {
    /// The official server time for Bybit.
    struct BybitServerTime {
        /// The server time in seconds.
        let time: String?
        
        /// Server data about the response.
        let metaData: BitService.BybitResponseMetaData
    }
}

extension BitService.BybitServerTime: Model {

    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case time = "time_now"
    }

    public init(from decoder: Decoder) throws {
        self.metaData = try BitService.BybitResponseMetaData(from: decoder)
        self.time = metaData.timeNow
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(time, forKey: .time)
    }
}
