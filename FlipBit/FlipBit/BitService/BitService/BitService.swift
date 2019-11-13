//
//  BitService.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public struct BitService {
    /// The configuration data used for initializing `BitService` instance.
    private let configuration: BitService.Configuration
    
    /// Creates a `BitService` instance given the provided parameter(s).
    public init() {
        self.configuration = BitService.Configuration()
    }
}

public extension BitService {
    
    enum Currency: String, Codable {
        case BTC = "BTC"
        case ETH = "ETH"
        case EOS = "EOS"
        case XRP = "XRP"
    }
    
    enum BybitSymbol: String, Codable {
        case BTC = "BTCUSD"
        case ETH = "ETHUSD"
        case EOS = "EOSUSD"
        case XRP = "XRPUSD"
    }
    
    enum BybitFundingEvent: String, Codable {
        case Deposit
        case Withdraw
        case RealisedPNL = "Realized P&L"
        case Commission
        case Refund
        case Prize
        case ExchangeOrderWithdraw
        case ExchangeOrderDeposit
    }
    
    enum BybitOrderSide: String, Codable {
        case Buy
        case Sell
    }
    
    func lookupBybitAPIKeyInfo(completion: @escaping (Result<BybitAPIKeyInfo, BitService.Error>) -> Void) {
        let endpoint = BybitAPIKeyInfo.Endpoint(timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitAPIKeyInfo.self, on: completion)
    }
    
    func lookupBybitOrderBook(symbol: BybitSymbol, completion: @escaping (Result<BybitOrderbook, BitService.Error>) -> Void) {
        let endpoint = BybitOrderbook.Endpoint.init(symbol: symbol)
        service.load(endpoint, expecting: BybitOrderbook.self, on: completion)
    }
    
    func lookupBybitPredictedFunding(symbol: BybitSymbol, completion: @escaping (Result<BybitPredictedFunding, BitService.Error>) -> Void) {
        let endpoint = BybitPredictedFunding.Endpoint.init(symbol: symbol, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitPredictedFunding.self, on: completion)
    }
    
    func lookupBybitPreviousFunding(symbol: BybitSymbol, completion: @escaping (Result<BybitPreviousFundingFee, BitService.Error>) -> Void) {
        let endpoint = BybitPreviousFundingFee.Endpoint.init(symbol: symbol, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitPreviousFundingFee.self, on: completion)
    }
    
    func lookupBybitServerTime(completion: @escaping (Result<BybitServerTime, BitService.Error>) -> Void) {
        let endpoint = BybitServerTime.Endpoint.init()
        service.load(endpoint, expecting: BybitServerTime.self, on: completion)
    }
    
    func lookupBybitTickers(symbol: BybitSymbol, completion: @escaping (Result<BybitTickers, BitService.Error>) -> Void) {
        let endpoint = BybitTickers.Endpoint.init(symbol: symbol)
        service.load(endpoint, expecting: BybitTickers.self, on: completion)
    }
    
    func lookupBybitWalletRecord(currency: Currency, pageNumber: Int, completion: @escaping (Result<BybitWalletRecords, BitService.Error>) -> Void) {
        let endpoint = BybitWalletRecords.Endpoint.init(currency: currency, pageNumber: pageNumber, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitWalletRecords.self, on: completion)
    }
}
