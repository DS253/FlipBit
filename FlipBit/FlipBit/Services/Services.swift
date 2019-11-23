//
//  Services.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/19/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

typealias Service = NetQuilt
typealias ServiceError = NetQuiltError

let services: Services = {
    Services()
}()

class Services {
    
    typealias StandardServiceCompletion = (Error?) -> Void
    typealias ResponseServiceCompletion<T: Model> = (T?, Error?) -> Void
    typealias BitServiceAPILookupCompletion = (Result<BitService.BybitAPIKeyInfo, BitService.Error>) -> Void
    typealias BitServiceActiveOrderLookupCompletion = (Result<BitService.BybitActiveOrderList, BitService.Error>) -> Void
    typealias BitServiceOrderbookLookupCompletion = (Result<BitService.BybitOrderbook, BitService.Error>) -> Void
    typealias BitServiceOrderCreateCompletion = (Result<BitService.BybitOrderResponse, BitService.Error>) -> Void
    typealias BitServiceActiveOrderCancelCompletion = (Result<BitService.BybitCancelledOrder, BitService.Error>) -> Void
    typealias BitServiceActiveOrderUpdateCompletion = (Result<BitService.BybitActiveOrderUpdate, BitService.Error>) -> Void
    typealias BitServiceLeverageLookupCompletion = (Result<BitService.BybitLeverageStatus, BitService.Error>) -> Void
    typealias BitServiceLeverageUpdateCompletion = (Result<BitService.BybitLeverageUpdate, BitService.Error>) -> Void
    typealias BitServicePositionLookupCompletion = (Result<BitService.BybitPositionList, BitService.Error>) -> Void
    typealias BitServicePredictedFundingLookupCompletion = (Result<BitService.BybitPredictedFunding, BitService.Error>) -> Void
    typealias BitServicePreviousFundingLookupCompletion = (Result<BitService.BybitPreviousFundingFee, BitService.Error>) -> Void
    typealias BitServicePreviousFundingRateLookupCompletion = (Result<BitService.BybitPreviousFundingRate, BitService.Error>) -> Void
    typealias BitServiceServerTimeLookupCompletion = (Result<BitService.BybitServerTime, BitService.Error>) -> Void
    typealias BitServiceTickersLookupCompletion = (Result<BitService.BybitTickerList, BitService.Error>) -> Void
    typealias BitServiceTradeRecordLookupCompletion = (Result<BitService.BybitTradeRecords, BitService.Error>) -> Void
    typealias BitServiceWalletRecordLookupCompletion = (Result<BitService.BybitWalletRecords, BitService.Error>) -> Void
    typealias BitServiceWithdrawRecordLookupCompletion = (Result<BitService.BybitWithdrawalRecords, BitService.Error>) -> Void
    typealias BybitAPIKeyInfo = BitService.BybitAPIKeyInfo
    
    let api: Service = {
        Service(sessionConfiguration: Service.NetSessionConfiguration())
    }()
    
    let bitService: BitService = BitService()
    
    func fetchBybitAPIKeyInfo(completion: @escaping BitServiceAPILookupCompletion) {
        bitService.lookupBybitAPIKeyInfo(completion: completion)
    }
    
    func fetchBybitActiveOrderList(symbol: BitService.BybitSymbol, pageNumber: Int, orderStatus: BitService.BybitOrderStatus? = nil, completion: @escaping BitServiceActiveOrderLookupCompletion) {
        bitService.lookupBybitActiveOrders(symbol: symbol, pageNumber: pageNumber, orderStatus: orderStatus, completion: completion)
    }
    
    func fetchBybitLeverageStatus(completion: @escaping BitServiceLeverageLookupCompletion) {
        bitService.lookupBybitLeverage(completion: completion)
    }
    
    func updateBybitLeverage(symbol: BitService.BybitSymbol, leverage: String, completion: @escaping BitServiceLeverageUpdateCompletion) {
        bitService.postBybitLeverageUpdate(symbol: symbol, leverage: leverage, completion: completion)
    }
    
    func fetchBybitOrderBook(symbol: BitService.BybitSymbol, completion: @escaping BitServiceOrderbookLookupCompletion) {
        bitService.lookupBybitOrderBook(symbol: symbol, completion: completion)
    }
    
    func fetchBybitPosition(completion: @escaping BitServicePositionLookupCompletion) {
        bitService.lookupBybitPosition(completion: completion)
    }
    
    func fetchBybitPredictedFunding(symbol: BitService.BybitSymbol, completion: @escaping BitServicePredictedFundingLookupCompletion) {
        bitService.lookupBybitPredictedFunding(symbol: symbol, completion: completion)
    }
    
    func fetchBybitPreviousFunding(symbol: BitService.BybitSymbol, completion: @escaping BitServicePreviousFundingLookupCompletion) {
        bitService.lookupBybitPreviousFunding(symbol: symbol, completion: completion)
    }
    
    func fetchBybitPreviousFundingRate(symbol: BitService.BybitSymbol, completion: @escaping BitServicePreviousFundingRateLookupCompletion) {
        bitService.lookupBybitPreviousFundingRate(symbol: symbol, completion: completion)
    }
    
    func fetchBybitServerTime(completion: @escaping BitServiceServerTimeLookupCompletion) {
        bitService.lookupBybitServerTime(completion: completion)
    }
    
    func fetchBybitTradeRecords(symbol: BitService.BybitSymbol, pageNumber: Int, completion: @escaping BitServiceTradeRecordLookupCompletion) {
        bitService.lookupBybitTradeRecords(symbol: symbol, pageNumber: pageNumber, completion: completion)
    }
    
    func fetchBybitTickers(symbol: BitService.BybitSymbol, completion: @escaping BitServiceTickersLookupCompletion) {
        bitService.lookupBybitTickers(symbol: symbol, completion: completion)
    }
    
    func fetchBybitWalletRecords(currency: BitService.Currency, pageNumber: Int, completion: @escaping BitServiceWalletRecordLookupCompletion) {
        bitService.lookupBybitWalletRecord(currency: currency, pageNumber: pageNumber, completion: completion)
    }
    
    func fetchBybitWithdrawRecords(currency: BitService.Currency, pageNumber: Int, completion: @escaping BitServiceWithdrawRecordLookupCompletion) {
        bitService.lookupBybitWithdrawRecord(currency: currency, pageNumber: pageNumber, completion: completion)
    }
    
    func createBybitActiveOrder(side: BitService.BybitOrderSide, symbol: BitService.BybitSymbol, orderType: BitService.BybitOrderType, quantity: Int, timeInForce: BitService.BybitOrderTimeInForce, price: Double? = nil, takeProfit: Double? = nil, stopLoss: Double? = nil, reduceOnly: Bool? = nil, closeOnTrigger: Bool? = nil, orderLinkID: String? = nil, completion: @escaping BitServiceOrderCreateCompletion) {
        bitService.postBybitCreateActiveOrder(side: side, symbol: symbol, orderType: orderType, quantity: quantity, timeInForce: timeInForce, price: price, takeProfit: takeProfit, stopLoss: stopLoss, reduceOnly: reduceOnly, closeOnTrigger: closeOnTrigger, orderLinkID: orderLinkID, completion: completion)
    }
    
    func cancelBybitActiveOrder(orderID: String? = nil, orderLinkID: String? = nil, completion: @escaping BitServiceActiveOrderCancelCompletion) {
        bitService.postBybitCancelActiveOrder(orderID: orderID, orderLinkID: orderLinkID, completion: completion)
    }
    
    func updateBybitActiveOrder(orderID: String, symbol: BitService.BybitSymbol, quantity: Int? = nil, price: Double? = nil, completion: @escaping BitServiceActiveOrderUpdateCompletion) {
        bitService.postBybitUpdateActiveOrder(orderID: orderID, symbol: symbol, quantity: quantity, price: price, completion: completion)
    }
    
//    private func load<Endpoint: Requestable, Expecting: Model>(endpoint: Endpoint, completion: ResponseServiceCompletion<Expecting>? = nil) {
//
//        api.load(endpoint).execute(expecting: Expecting.self) { [weak self] result in
//
//            switch result {
//            case let .success(result):
//                completion?(result, nil)
//
//            case let .failure(error):
//                print("Failure")
//                completion?(nil, error)
//            }
//        }
//    }
}
