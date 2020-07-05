//
//  Bybit+SymbolInfo.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/25/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension Bybit {
    /// A type that represent a `SymbolInfo` object returned from the Bybit API
    struct SymbolInfo: Codable {
        /// The id for the Symbol.
        var id: Int?
        
        /// The symbol.
        var symbol: Bybit.Symbol?
        
        /// The price which the most recent transaction occurred at.
        var lastPrice: Int?
        
        /// The direction price has moved.
        var tickDirection: Bybit.TickDirection?
        
        /// The price 24 hours ago.
        var prevPrice24H: Int?
        
        /// The percentage change in price the last 24 hours.
        var prevPcnt24H: String?
        
        /// The highest the price has reached the last 24 hours.
        var highPrice24H: Int?
        
        /// The lowest the price has reached the last 24 hours.
        var lowPrice24H: Int?
        
        /// The price 1 hour ago.
        var prevPrice1H: Int?
        
        /// The percentage change in price in the last hour.
        var prevPcnt1H: Int?
        
        /// The Mark price - real-time spot price on the major exchanges.
        var markPrice: Int?
        
        /// The current index price.
        var indexPrice: Int?
        
        /// The current open interest.
        var openInterest: Int?
        
        /// The open value.
        var openValue: Int?
        
        /// Total number of coins turned over.
        var totalTurnover: Int?
        
        /// The number of coins turned over in the last 24 hours.
        var turnover24H: String?
        
        /// Total turned over in USD.
        var totalVolume: Int?
        
        /// Total turned over in USD in the last 24 hours.
        var volume24H: Int?
        
        /// The current funding rate.
        var fundingRate: String?
        
        /// The predicted funding rate.
        var predictedFundingRate: String?
        
        var crossSequence: Int?
        
        var createdAt: String?
        
        var updatedAt: String?
        
        /// The time the next funding fee settlement will occur.
        var nextFundingTime: String?
        
        /// The number of hours until the next funding fee is settled.
        var countdownToFundingFee: Int?
        
        enum CodingKeys: String, CodingKey {
            case id
            case symbol
            case lastPrice = "last_price_e4"
            case tick = "last_tick_direction"
            case prevPrice24H = "prev_price_24h_e4"
            case prevPcnt24H = "price_24h_pcnt_e6"
            case highPrice24H = "high_price_24h_e4"
            case lowPrice24H = "low_price_24h_e4"
            case prevPrice1H = "prev_price_1h_e4"
            case prevPcnt1H = "price_1h_pcnt_e6"
            case markPrice = "mark_price_e4"
            case indexPrice = "index_price_e4"
            case openInterest = "open_interest"
            case openValue = "open_value_e8"
            case totalTurnover = "total_turnover_e8"
            case turnover24H = "turnover_24h_e8"
            case totalVolume = "total_volume"
            case volume24H = "volume_24h"
            case fundingRate = "funding_rate_e6"
            case predictedFunding = "predicted_funding_rate_e6"
            case cross = "cross_seq"
            case createdAt = "created_at"
            case updated = "updated_at"
            case fundingTime = "next_funding_time"
            case countdown = "countdown_hour"
        }
        
        init(from decoder: Decoder) throws {
            let results = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try results.decodeIfPresent(Int.self, forKey: .id)
            self.symbol = try results.decodeIfPresent(Bybit.Symbol.self, forKey: .symbol)
            self.lastPrice = try results.decodeIfPresent(Int.self, forKey: .lastPrice)
            self.tickDirection = try results.decodeIfPresent(Bybit.TickDirection.self, forKey: .tick)
            self.prevPrice24H = try results.decodeIfPresent(Int.self, forKey: .prevPrice24H)
            let percent24 =  try results.decodeIfPresent(Int.self, forKey: .prevPcnt24H)
            self.prevPcnt24H = percent24?.formatPriceString(notation: 4)
            self.highPrice24H = try results.decodeIfPresent(Int.self, forKey: .highPrice24H)
            self.lowPrice24H = try results.decodeIfPresent(Int.self, forKey: .lowPrice24H)
            self.prevPrice1H = try results.decodeIfPresent(Int.self, forKey: .prevPrice1H)
            self.prevPcnt1H = try results.decodeIfPresent(Int.self, forKey: .prevPcnt1H)
            self.markPrice = try results.decodeIfPresent(Int.self, forKey: .markPrice)
            self.indexPrice = try results.decodeIfPresent(Int.self, forKey: .indexPrice)
            self.openInterest = try results.decodeIfPresent(Int.self, forKey: .openInterest)
            self.openValue = try results.decodeIfPresent(Int.self, forKey: .openValue)
            self.totalTurnover = try results.decodeIfPresent(Int.self, forKey: .totalTurnover)
            let turnover24 = try results.decodeIfPresent(Int.self, forKey: .turnover24H)
            self.turnover24H = turnover24?.formatWithKNotation(notation: 8)
            self.totalVolume = try results.decodeIfPresent(Int.self, forKey: .totalVolume)
            self.volume24H = try results.decodeIfPresent(Int.self, forKey: .volume24H)
            let rate = try results.decodeIfPresent(Int.self, forKey: .fundingRate)
            self.fundingRate = rate?.formatPriceString(notation: 4)
            let predictedRate = try results.decodeIfPresent(Int.self, forKey: .predictedFunding)
            self.predictedFundingRate = predictedRate?.formatPriceString(notation: 6)
            self.crossSequence = try results.decodeIfPresent(Int.self, forKey: .cross)
            
            self.createdAt = try results.decodeIfPresent(String.self, forKey: .createdAt)
            self.updatedAt = try results.decodeIfPresent(String.self, forKey: .updated)
            self.nextFundingTime = try results.decodeIfPresent(String.self, forKey: .fundingTime)
            self.countdownToFundingFee = try results.decodeIfPresent(Int.self, forKey: .countdown)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(id, forKey: .id)
            try container.encodeIfPresent(symbol, forKey: .symbol)
            try container.encodeIfPresent(lastPrice, forKey: .lastPrice)
            try container.encodeIfPresent(tickDirection, forKey: .tick)
            try container.encodeIfPresent(prevPrice24H, forKey: .prevPrice24H)
            try container.encodeIfPresent(prevPcnt24H, forKey: .prevPcnt24H)
            try container.encodeIfPresent(highPrice24H, forKey: .highPrice24H)
            try container.encodeIfPresent(lowPrice24H, forKey: .lowPrice24H)
            try container.encodeIfPresent(prevPrice1H, forKey: .prevPrice1H)
            try container.encodeIfPresent(prevPcnt1H, forKey: .prevPcnt1H)
            try container.encodeIfPresent(markPrice, forKey: .markPrice)
            try container.encodeIfPresent(indexPrice, forKey: .indexPrice)
            try container.encodeIfPresent(openInterest, forKey: .openInterest)
            try container.encodeIfPresent(openValue, forKey: .openValue)
            try container.encodeIfPresent(totalTurnover, forKey: .totalTurnover)
            try container.encodeIfPresent(turnover24H, forKey: .turnover24H)
            try container.encodeIfPresent(totalVolume, forKey: .totalVolume)
            try container.encodeIfPresent(volume24H, forKey: .volume24H)
            try container.encodeIfPresent(fundingRate, forKey: .fundingRate)
            try container.encodeIfPresent(predictedFundingRate, forKey: .fundingRate)
            try container.encodeIfPresent(crossSequence, forKey: .cross)
            try container.encodeIfPresent(createdAt, forKey: .createdAt)
            try container.encodeIfPresent(updatedAt, forKey: .updated)
            try container.encodeIfPresent(nextFundingTime, forKey: .fundingTime)
            try container.encodeIfPresent(countdownToFundingFee, forKey: .countdown)
        }
    }
}
