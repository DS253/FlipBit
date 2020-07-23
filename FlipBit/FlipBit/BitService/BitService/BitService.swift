//
//  BitService.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Atom
import Foundation

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
        case USDT = "BTCUSDT"
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
    
    enum BybitOrderTimeInForce: String, Codable {
        case GoodTillCancel
        case ImmediateOrCancel
        case FillOrKill
        case PostOnly
        case Other = ""
    }
    
    enum BybitOrderStatus: String, Codable {
        case Created
        case New
        case PartiallyFilled
        case Filled
        case Cancelled
        case Rejected
        case NotActive
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
    
    func lookupBybitActiveOrders(symbol: Bybit.Symbol, pageNumber: Int, orderStatus: BitService.BybitOrderStatus?, completion: @escaping (Result<BybitActiveOrderList, BitService.Error>) -> Void) {
        let endpoint = BybitActiveOrderList.Endpoint(symbol: symbol, pageNumber: pageNumber, orderStatus: orderStatus, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitActiveOrderList.self, on: completion)
    }
    
    func lookupBybitLeverage(completion: @escaping (Result<BybitLeverageStatus, BitService.Error>) -> Void) {
        let endpoint = BybitLeverageStatus.Endpoint.init(timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitLeverageStatus.self, on: completion)
    }
    
    func postBybitLeverageUpdate(symbol: Bybit.Symbol, leverage: String, completion: @escaping (Result<BybitLeverageUpdate, BitService.Error>) -> Void) {
        let endpoint = BybitLeverageUpdate.Endpoint.init(symbol: symbol, leverage: leverage, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitLeverageUpdate.self, on: completion)
    }
    
    func lookupBybitOrderBook(symbol: Bybit.Symbol, completion: @escaping (Result<BybitOrderbook, BitService.Error>) -> Void) {
        let endpoint = BybitOrderbook.Endpoint.init(symbol: symbol)
        service.load(endpoint, expecting: BybitOrderbook.self, on: completion)
    }
    
    func lookupBybitPosition(completion: @escaping (Result<BybitPositionList, BitService.Error>) -> Void) {
        let endpoint = BybitPositionList.Endpoint.init(timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitPositionList.self, on: completion)
    }
    
    func lookupBybitPredictedFunding(symbol: Bybit.Symbol, completion: @escaping (Result<BybitPredictedFunding, BitService.Error>) -> Void) {
        let endpoint = BybitPredictedFunding.Endpoint.init(symbol: symbol, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitPredictedFunding.self, on: completion)
    }
    
    func lookupBybitPreviousFunding(symbol: Bybit.Symbol, completion: @escaping (Result<BybitPreviousFundingFee, BitService.Error>) -> Void) {
        let endpoint = BybitPreviousFundingFee.Endpoint.init(symbol: symbol, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitPreviousFundingFee.self, on: completion)
    }
    
    func lookupBybitPreviousFundingRate(symbol: Bybit.Symbol, completion: @escaping (Result<BybitPreviousFundingRate, BitService.Error>) -> Void) {
        let endpoint = BybitPreviousFundingRate.Endpoint.init(symbol: symbol, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitPreviousFundingRate.self, on: completion)
    }
    
    func lookupBybitServerTime(completion: @escaping (Result<BybitServerTime, BitService.Error>) -> Void) {
        let endpoint = BybitServerTime.Endpoint.init()
        service.load(endpoint, expecting: BybitServerTime.self, on: completion)
    }
    
    func lookupBybitTickers(symbol: Bybit.Symbol? = nil, completion: @escaping (Result<BybitTickerList, BitService.Error>) -> Void) {
        let endpoint = BybitTickerList.Endpoint.init(symbol: symbol)
        service.load(endpoint, expecting: BybitTickerList.self, on: completion)
    }
    
    func lookupBybitTradeRecords(symbol: Bybit.Symbol, pageNumber: Int, completion: @escaping (Result<BybitTradeRecords, BitService.Error>) -> Void) {
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
    
    func postBybitCreateActiveOrder(side: BitService.BybitOrderSide, symbol: Bybit.Symbol, orderType: BitService.BybitOrderType, quantity: Int,
                                    timeInForce: BitService.BybitOrderTimeInForce, price: Double? = nil, takeProfit: Double? = nil, stopLoss: Double? = nil,
                                    reduceOnly: Bool? = nil, closeOnTrigger: Bool? = nil, orderLinkID: String? = nil, completion: @escaping (Result<BybitOrderResponse, BitService.Error>) -> Void) {
        let endpoint = BybitOrder.Endpoint.init(side: side, symbol: symbol, orderType: orderType, quantity: quantity, timeInForce: timeInForce,
                                                price: price, takeProfit: takeProfit, stopLoss: stopLoss, reduceOnly: reduceOnly, closeOnTrigger: closeOnTrigger,
                                                orderLinkID: orderLinkID, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitOrderResponse.self, on: completion)
    }
    
    func postBybitCancelActiveOrder(orderID: String? = nil, orderLinkID: String? = nil, completion: @escaping (Result<BybitCancelledOrder, BitService.Error>) -> Void) {
        let endpoint = BybitCancelledOrder.Endpoint.init(orderID: orderID, orderLinkID: orderLinkID, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitCancelledOrder.self, on: completion)
    }
    
    func postBybitUpdateActiveOrder(orderID: String, symbol: Bybit.Symbol, quantity: Int? = nil, price: Double? = nil, completion: @escaping (Result<BybitActiveOrderUpdate, BitService.Error>) -> Void) {
        let endpoint = BybitActiveOrderUpdate.Endpoint.init(orderID: orderID, symbol: symbol, quantity: quantity, price: price, timeStamp: Date().bybitTimestamp())
        service.load(endpoint, expecting: BybitActiveOrderUpdate.self, on: completion)
    }
}
