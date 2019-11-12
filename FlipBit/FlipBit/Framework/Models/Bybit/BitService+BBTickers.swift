//
//  BitService+BBTickers.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

struct BybitTickerItem {
    
    // The symbol of the ticker.
    let symbol: String
    
    // The highest bid price.
    let bidPrice: String
    
    // The lowest ask price.
    let askPrice: String
    
    // The price which the most recent transaction occurred at.
    let lastPrice: String
    
    // The direction price has moved.
    let lastTickDirection: String
    
    // The price 24 hours ago.
    let prevPrice24H: String
    
    // The percentage change in price the last 24 hours.
    let prevPcnt24H: String
    
    // The highest the price has reached the last 24 hours.
    let highPrice24H: String
    
    // The lowest the price has reached the last 24 hours.
    let lowPrice24H: String
    
    // The price 1 hour ago.
    let prevPrice1H: String
    
    // The percentage change in price in the last hour.
    let prevPcnt1H: String
    
    // The Mark price - real-time spot price on the major exchanges.
    let markPrice: String
    
    // The current index price.
    let indexPrice: String
    
    // The current open interest.
    let openInterest: Int
    
    // The open value.
    let openValue: String
    
    // Total number of coins turned over.
    let totalTurnover: String
    
    // The number of coins turned over in the last 24 hours.
    let turnover24H: String
    
    // Total turned over in USD.
    let totalVolume: Int
    
    // Total turned over in USD in the last 24 hours.
    let volume24H: Int
    
    // The current funding rate.
    let fundingRate: String
    
    // The predicted funding rate.
    let predictedFundingRate: String
    
    // The time the next funding rate change will occur.
    let nextFundingTime: String
    
    // The number of hours until the next funding rate will occur.
    let fundingRateCountdown: Int
}

extension BybitTickerItem: Model {
    /// List of top level coding keys.
    enum CodingKeys: String, CodingKey {
        case symbol
        case bidPrice = "bid_price"
        case askPrice = "ask_price"
        case lastPrice = "last_price"
        case lastTickDirection = "last_tick_direction"
        case prevPrice24 = "prev_price_24h"
        case prevPcnt24 = "price_24h_pcnt"
        case highPrice24 = "high_price_24h"
        case lowPrice24 = "low_price_24h"
        case prevPrice1 = "prev_price_1h"
        case prevPcnt1 = "price_1h_pcnt"
        case markPrice = "mark_price"
        case indexPrice = "index_price"
        case openInterest = "open_interest"
        case openValue = "open_value"
        case totalTurnover = "total_turnover"
        case turnover24 = "turnover_24h"
        case totalVolume = "total_volume"
        case volume24 = "volume_24h"
        case fundingRate = "funding_rate"
        case predictedFundRate = "predicted_funding_rate"
        case nextFundingTime = "next_funding_time"
        case fundingCountdown = "countdown_hour"
    }
    
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        
        self.symbol = try data.decode(String.self, forKey: .symbol)
        self.bidPrice = try data.decode(String.self, forKey: .bidPrice)
        self.askPrice = try data.decode(String.self, forKey: .askPrice)
        self.lastPrice = try data.decode(String.self, forKey: .lastPrice)
        self.lastTickDirection = try data.decode(String.self, forKey: .lastTickDirection)
        self.prevPrice24H = try data.decode(String.self, forKey: .prevPrice24)
        self.prevPcnt24H = try data.decode(String.self, forKey: .prevPcnt24)
        self.highPrice24H = try data.decode(String.self, forKey: .highPrice24)
        self.lowPrice24H = try data.decode(String.self, forKey: .lowPrice24)
        self.prevPrice1H = try data.decode(String.self, forKey: .prevPrice1)
        self.prevPcnt1H = try data.decode(String.self, forKey: .prevPcnt1)
        self.markPrice = try data.decode(String.self, forKey: .markPrice)
        self.indexPrice = try data.decode(String.self, forKey: .indexPrice)
        self.openInterest = try data.decode(Int.self, forKey: .openInterest)
        self.openValue = try data.decode(String.self, forKey: .openValue)
        self.totalTurnover = try data.decode(String.self, forKey: .totalTurnover)
        self.turnover24H = try data.decode(String.self, forKey: .turnover24)
        self.totalVolume = try data.decode(Int.self, forKey: .totalVolume)
        self.volume24H = try data.decode(Int.self, forKey: .volume24)
        self.fundingRate = try data.decode(String.self, forKey: .fundingRate)
        self.predictedFundingRate = try data.decode(String.self, forKey: .predictedFundRate)
        self.nextFundingTime = try data.decode(String.self, forKey: .nextFundingTime)
        self.fundingRateCountdown = try data.decode(Int.self, forKey: .fundingCountdown)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(symbol, forKey: .symbol)
        try container.encode(bidPrice, forKey: .bidPrice)
        try container.encode(askPrice, forKey: .askPrice)
        try container.encode(lastPrice, forKey: .lastPrice)
        try container.encode(lastTickDirection, forKey: .lastTickDirection)
        try container.encode(prevPrice24H, forKey: .prevPrice24)
        try container.encode(prevPcnt24H, forKey: .prevPcnt24)
        try container.encode(highPrice24H, forKey: .highPrice24)
        try container.encode(lowPrice24H, forKey: .lowPrice24)
        try container.encode(prevPrice1H, forKey: .prevPrice1)
        try container.encode(prevPcnt1H, forKey: .prevPcnt1)
        try container.encode(markPrice, forKey: .markPrice)
        try container.encode(indexPrice, forKey: .indexPrice)
        try container.encode(openInterest, forKey: .openInterest)
        try container.encode(openValue, forKey: .openValue)
        try container.encode(totalTurnover, forKey: .totalTurnover)
        try container.encode(turnover24H, forKey: .turnover24)
        try container.encode(totalVolume, forKey: .totalVolume)
        try container.encode(volume24H, forKey: .volume24)
        try container.encode(fundingRate, forKey: .fundingRate)
        try container.encode(predictedFundingRate, forKey: .predictedFundRate)
        try container.encode(nextFundingTime, forKey: .nextFundingTime)
        try container.encode(fundingRateCountdown, forKey: .fundingCountdown)
    }
}

struct BybitTickers {
    let returnCode: Int
    let response: BybitTickers.Response
    let exitCode: String
    let exitInfo: String
    let time: String
    let tickers: [BybitTickerItem]
    
    enum Response: String, Decodable {
        case OK
        case failure
    }
}

extension BybitTickers: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case exit = "ext_code"
        case info = "ext_info"
        case response = "ret_msg"
        case returnCode = "ret_code"
        case result
        case time = "time_now"
    }
        
    internal init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.returnCode = try values.decode(Int.self, forKey: .returnCode)
        self.exitCode = try values.decode(String.self, forKey: .exit)
        self.exitInfo = try values.decode(String.self, forKey: .info)
        self.time = try values.decode(String.self, forKey: .time)
        self.response = try values.decode(Response.self, forKey: .response)
        
        self.tickers = try values.decode([BybitTickerItem].self, forKey: .result)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tickers, forKey: .result)
    }
}

