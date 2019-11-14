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
    
    enum BybitExecutionType: String, Codable {
        case Funding
        case Trade
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
    
    enum BybitLiquidity: String, Codable {
        case AddedLiquidity
        case RemovedLiquidity
        case Other = ""
    }
    
    enum BybitMarginMode: Int, Codable {
        case Isolated = 0
        case Cross = 1
    }
    
    enum BybitOrderSide: String, Codable {
        case Buy
        case Sell
        case None
    }
    
    enum BybitOrderType: String, Codable {
        case Limit
        case Market
        case Other = ""
    }
    
    enum BybitPositionStatus: String, Codable {
        case ADL
        case Liq
        case Normal
    }
    
    enum BybitSymbol: String, Codable {
        case BTC = "BTCUSD"
        case ETH = "ETHUSD"
        case EOS = "EOSUSD"
        case XRP = "XRPUSD"
    }
    
    enum BybitWithdrawalStatus: String, Codable {
        case ToBeConfirmed
        case UnderReview
        case Pending
        case Success
        case CancelByUser
        case Reject
        case Expire
    }
    
    func lookupBybitAPIKeyInfo(completion: @escaping (Result<BybitAPIKeyInfo, BitService.Error>) -> Void) {
        let endpoint = BybitAPIKeyInfo.Endpoint(timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitAPIKeyInfo.self, on: completion)
    }
    
    func lookupBybitOrderBook(symbol: BybitSymbol, completion: @escaping (Result<BybitOrderbook, BitService.Error>) -> Void) {
        let endpoint = BybitOrderbook.Endpoint.init(symbol: symbol)
        service.load(endpoint, expecting: BybitOrderbook.self, on: completion)
    }
    
    func lookupBybitPosition(completion: @escaping (Result<BybitPositionList, BitService.Error>) -> Void) {
        let endpoint = BybitPositionList.Endpoint.init(timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitPositionList.self, on: completion)
    }
    
    func lookupBybitPredictedFunding(symbol: BybitSymbol, completion: @escaping (Result<BybitPredictedFunding, BitService.Error>) -> Void) {
        let endpoint = BybitPredictedFunding.Endpoint.init(symbol: symbol, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitPredictedFunding.self, on: completion)
    }
    
    func lookupBybitPreviousFunding(symbol: BybitSymbol, completion: @escaping (Result<BybitPreviousFundingFee, BitService.Error>) -> Void) {
        let endpoint = BybitPreviousFundingFee.Endpoint.init(symbol: symbol, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitPreviousFundingFee.self, on: completion)
    }
    
    func lookupBybitPreviousFundingRate(symbol: BybitSymbol, completion: @escaping (Result<BybitPreviousFundingRate, BitService.Error>) -> Void) {
        let endpoint = BybitPreviousFundingRate.Endpoint.init(symbol: symbol, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitPreviousFundingRate.self, on: completion)
    }
    
    func lookupBybitServerTime(completion: @escaping (Result<BybitServerTime, BitService.Error>) -> Void) {
        let endpoint = BybitServerTime.Endpoint.init()
        service.load(endpoint, expecting: BybitServerTime.self, on: completion)
    }
    
    func lookupBybitTickers(symbol: BybitSymbol, completion: @escaping (Result<BybitTickers, BitService.Error>) -> Void) {
        let endpoint = BybitTickers.Endpoint.init(symbol: symbol)
        service.load(endpoint, expecting: BybitTickers.self, on: completion)
    }
    
    func lookupBybitTradeRecords(symbol: BybitSymbol, pageNumber: Int, completion: @escaping (Result<BybitTradeRecords, BitService.Error>) -> Void) {
        let endpoint = BybitTradeRecords.Endpoint.init(symbol: symbol, pageNumber: pageNumber, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitTradeRecords.self, on: completion)
    }
    
    func lookupBybitWalletRecord(currency: Currency, pageNumber: Int, completion: @escaping (Result<BybitWalletRecords, BitService.Error>) -> Void) {
        let endpoint = BybitWalletRecords.Endpoint.init(currency: currency, pageNumber: pageNumber, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitWalletRecords.self, on: completion)
    }
    
    func lookupBybitWithdrawRecord(currency: Currency, pageNumber: Int, completion: @escaping (Result<BybitWithdrawalRecords, BitService.Error>) -> Void) {
        let endpoint = BybitWithdrawalRecords.Endpoint.init(currency: currency, pageNumber: pageNumber, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitWithdrawalRecords.self, on: completion)
    }
}
