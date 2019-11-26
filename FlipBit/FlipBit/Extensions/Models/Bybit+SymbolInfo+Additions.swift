//
//  Bybit+SymbolInfo+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/25/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension Bybit.SymbolInfo {
    mutating func updateSymbolInfo(newSymbol: Bybit.SymbolInfo?) {
        guard let info = newSymbol else { return }
        
        if let newID = info.id {
            self.id = newID
        }
        
        if let newSymbol = info.symbol {
            self.symbol = newSymbol
        }
        
        if let newLastPrice = info.lastPrice {
            self.lastPrice = newLastPrice
        }
        
        if let newTick = info.tickDirection {
            self.tickDirection = newTick
        }
        
        if let newPrevPrice24 = info.prevPrice24H {
            self.prevPrice24H = newPrevPrice24
        }
        
        if let newPrevPct24 = info.prevPcnt24H {
            self.prevPcnt24H = newPrevPct24
        }
        
        if let newHighPrice24 = info.highPrice24H {
            self.highPrice24H = newHighPrice24
        }
        
        if let newLowPrice24 = info.lowPrice24H {
            self.lowPrice24H = newLowPrice24
        }
        
        if let newPrevPrice1h = info.prevPrice1H {
            self.prevPrice1H = newPrevPrice1h
        }
        
        if let newPrevPct1 = info.prevPcnt1H {
            self.prevPcnt1H = newPrevPct1
        }
        
        if let newMarkPrice = info.markPrice {
            self.markPrice = newMarkPrice
        }
        
        if let newIndexPrice = info.indexPrice {
            self.indexPrice = newIndexPrice
        }
        
        if let newOpenInterest = info.openInterest {
            self.openInterest = newOpenInterest
        }
        
        if let newOpenValue = info.openValue {
            self.openValue = newOpenValue
        }
        
        if let newTurnover = info.totalTurnover {
            self.totalTurnover = newTurnover
        }
        
        if let newTurnover24 = info.turnover24H {
            self.turnover24H = newTurnover24
        }
        
        if let newVolume = info.totalVolume {
            self.totalVolume = newVolume
        }
        
        if let newVolume24 = info.volume24H {
            self.volume24H = newVolume24
        }
        
        if let newFundingRate = info.fundingRate {
            self.fundingRate = newFundingRate
        }
        
        if let newPredictedRate = info.predictedFundingRate {
            self.predictedFundingRate = newPredictedRate
        }
        
        if let newCross = info.crossSequence {
            self.crossSequence = newCross
        }
        
        if let newCreated = info.createdAt {
            self.createdAt = newCreated
        }
        
        if let newUpdated = info.updatedAt {
            self.updatedAt = newUpdated
        }
        
        if let newFundingTime = info.nextFundingTime {
            self.nextFundingTime = newFundingTime
        }
        
        if let newCountdown = info.countdownToFundingFee {
            self.countdownToFundingFee = newCountdown
        }
    }
}
