//
//  ViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import NetQuilt
import UIKit

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
    
    func createBybitOrder(side: BitService.BybitOrderSide, symbol: BitService.BybitSymbol, orderType: BitService.BybitOrderType, quantity: Int, timeInForce: BitService.BybitOrderTimeInForce, price: Double? = nil, takeProfit: Double? = nil, stopLoss: Double? = nil, reduceOnly: Bool? = nil, closeOnTrigger: Bool? = nil, orderLinkID: String? = nil, completion: @escaping BitServiceOrderCreateCompletion) {
        bitService.postBybitCreateOrder(side: side, symbol: symbol, orderType: orderType, quantity: quantity, timeInForce: timeInForce, price: price, takeProfit: takeProfit, stopLoss: stopLoss, reduceOnly: reduceOnly, closeOnTrigger: closeOnTrigger, orderLinkID: orderLinkID, completion: completion)
    }
    
    private func load<Endpoint: Requestable, Expecting: Model>(endpoint: Endpoint, completion: ResponseServiceCompletion<Expecting>? = nil) {

        api.load(endpoint).execute(expecting: Expecting.self) { [weak self] result in

            switch result {
            case let .success(result):
                completion?(result, nil)

            case let .failure(error):
                print("Failure")
                completion?(nil, error)
            }
        }
    }
}
    
class ViewController: UIViewController {

    var previousFunding: BitService.BybitPreviousFundingFee?
    var orderResponse: BitService.BybitOrderResponse?
    var orderList: BitService.BybitActiveOrderList?
    
    @IBOutlet weak var executeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func executeAction() {
        services.api.cancelAllSessionTasks()
        services.fetchBybitActiveOrderList(symbol: .BTC, pageNumber: 1) { result in
            switch result {
            case let .success(result):
                self.orderList = result
                guard let order = self.orderList else { return }
                print(order.activeOrders)
            case let .failure(error):
                print(error)
            }
            
        }
//        services.createBybitOrder(side: .Buy, symbol: .BTC, orderType: .Limit, quantity: 10000, timeInForce: .GoodTillCancel, price: 7000) { result in
//            switch result {
//            case let .success(result):
//                self.orderResponse = result
//                guard let order = self.orderResponse else { return }
//                print("UserID: \(order.orderData?.userID)")
//            case let .failure(error):
//                print(error)
//            }
//
//        }
//        services.fetchBybitPreviousFunding(symbol: .BTC) { result in
//            switch result {
//            case let .success(result):
//                self.previousFunding = result
//
//                guard
//                    let previous = self.previousFunding
//                else { return }
//                print(previous.feeData)
//                print("Return Code: \(previous.metaData.returnCode)")
//                print("Return Message: \(previous.metaData.returnMessage)")
//                print("External Code Error: \(previous.metaData.externalCodeError)")
//                print("Exit Info: \(previous.metaData.exitInfo)")
//                print("Time of Response: \(previous.metaData.timeNow)")
//                print("Rate Limit: \(previous.metaData.rateLimit)")
//                print("Rate Limit Status: \(previous.metaData.rateLimitStatus)")
//                print("Rate Limit Reset Time: \(previous.metaData.rateLimitResetTime)")
//
//            case let .failure(error):
//                print(error)
//            }
//        }
//        services.fetchBybitPredictedFunding(symbol: .BTC) { result in
//            switch result {
//            case let .success(result):
//                self.predictedFunding = result
//
//                guard
//                    let funding = self.predictedFunding
//                else { return }
//                print(funding.fundingRate)
//                print(funding.fundingFee)
//                print("Return Code: \(funding.metaData.returnCode)")
//                print("Return Message: \(funding.metaData.returnMessage)")
//                print("External Code Error: \(funding.metaData.externalCodeError)")
//                print("Exit Info: \(funding.metaData.exitInfo)")
//                print("Time of Response: \(funding.metaData.timeNow)")
//                print("Rate Limit: \(funding.metaData.rateLimit)")
//                print("Rate Limit Status: \(funding.metaData.rateLimitStatus)")
//                print("Rate Limit Reset Time: \(funding.metaData.rateLimitResetTime)")
//
//            case let .failure(error):
//                print(error)
//            }
//        }
//        services.fetchBybitPreviousFundingRate(symbol: .BTC) { result in
//            switch result {
//            case let .success(result):
//                self.fundingRate = result
//
//                guard
//                    let rate = self.fundingRate
//                else { return }
//                print(rate.rateData)
//                print("Return Code: \(rate.metaData.returnCode)")
//                print("Return Message: \(rate.metaData.returnMessage)")
//                print("External Code Error: \(rate.metaData.externalCodeError)")
//                print("Exit Info: \(rate.metaData.exitInfo)")
//                print("Time of Response: \(rate.metaData.timeNow)")
//                print("Rate Limit: \(rate.metaData.rateLimit)")
//                print("Rate Limit Status: \(rate.metaData.rateLimitStatus)")
//                print("Rate Limit Reset Time: \(rate.metaData.rateLimitResetTime)")
//
//            case let .failure(error):
//                print(error)
//            }
//        }
//        services.fetchBybitServerTime { result in
//            switch result {
//            case let .success(result):
//            self.time = result
//
//            guard
//                let time = self.time
//            else { return }
//            print(time.time)
//            print("Return Code: \(time.metaData.returnCode)")
//            print("Return Message: \(time.metaData.returnMessage)")
//            print("External Code Error: \(time.metaData.externalCodeError)")
//            print("Exit Info: \(time.metaData.exitInfo)")
//            print("Time of Response: \(time.metaData.timeNow)")
//            print("Rate Limit: \(time.metaData.rateLimit)")
//            print("Rate Limit Status: \(time.metaData.rateLimitStatus)")
//            print("Rate Limit Reset Time: \(time.metaData.rateLimitResetTime)")
//
//            case let .failure(error):
//                print(error)
//            }
//        }
//        services.fetchBybitTickers(symbol: .BTC) { result in
//            switch result {
//            case let .success(result):
//                self.tickers = result
//
//                guard
//                    let tickers = self.tickers
//                else { return }
//                print(tickers.tickers)
//                print("Return Code: \(tickers.metaData.returnCode)")
//                print("Return Message: \(tickers.metaData.returnMessage)")
//                print("External Code Error: \(tickers.metaData.externalCodeError)")
//                print("Exit Info: \(tickers.metaData.exitInfo)")
//                print("Time of Response: \(tickers.metaData.timeNow)")
//                print("Rate Limit: \(tickers.metaData.rateLimit)")
//                print("Rate Limit Status: \(tickers.metaData.rateLimitStatus)")
//                print("Rate Limit Reset Time: \(tickers.metaData.rateLimitResetTime)")
//
//            case let .failure(error):
//                print(error)
//            }
//        }
//        services.fetchBybitPosition { result in
//            switch result {
//            case let .success(result):
//                self.positions = result
//                guard
//                    let positions = self.positions
//                else { return }
//                print(positions.positions)
//                print("Return Code: \(positions.metaData.returnCode)")
//                print("Return Message: \(positions.metaData.returnMessage)")
//                print("External Code Error: \(positions.metaData.externalCodeError)")
//                print("Exit Info: \(positions.metaData.exitInfo)")
//                print("Time of Response: \(positions.metaData.timeNow)")
//                print("Rate Limit: \(positions.metaData.rateLimit)")
//                print("Rate Limit Status: \(positions.metaData.rateLimitStatus)")
//                print("Rate Limit Reset Time: \(positions.metaData.rateLimitResetTime)")
//
//            case let .failure(error):
//                print(error)
//            }
//        }
//        services.fetchBybitTradeRecords(symbol: .BTC, pageNumber: 1) { result in
//            switch result {
//            case let .success(result):
//                self.tradeRecords = result
//                guard
//                    let tradeRecord = self.tradeRecords
//                else { return }
//                print(tradeRecord.records)
//                print("Return Code: \(tradeRecord.metaData.returnCode)")
//                print("Return Message: \(tradeRecord.metaData.returnMessage)")
//                print("External Code Error: \(tradeRecord.metaData.externalCodeError)")
//                print("Exit Info: \(tradeRecord.metaData.exitInfo)")
//                print("Time of Response: \(tradeRecord.metaData.timeNow)")
//                print("Rate Limit: \(tradeRecord.metaData.rateLimit)")
//                print("Rate Limit Status: \(tradeRecord.metaData.rateLimitStatus)")
//                print("Rate Limit Reset Time: \(tradeRecord.metaData.rateLimitResetTime)")
//
//            case let .failure(error):
//                print(error)
//            }
//        }
//        services.fetchBybitOrderBook(symbol: .XRP) { result in
//            switch result {
//                case let .success(result):
//                    self.orderBook = result
//                    guard
//                        let orderBook = self.orderBook
//                        else { return }
//                    print(orderBook.book)
//                    print(orderBook.metaData.returnCode)
//                    print(orderBook.metaData.returnMessage)
//                    print(orderBook.metaData.externalCodeError)
//                    print(orderBook.metaData.exitInfo)
//                    print(orderBook.metaData.timeNow)
//                case let .failure(error):
//                    print(error)
//            }
//        }
        
//        services.fetchBybitWithdrawRecords(currency: .BTC, pageNumber: 1) { result in
//            switch result {
//            case let .success(result):
//                self.withdrawRecords = result
//                guard
//                    let records = self.withdrawRecords
//                    else { return }
//                print(records)
//                print(records.metaData.returnCode)
//                print(records.metaData.returnMessage)
//                print(records.metaData.externalCodeError)
//                print(records.metaData.exitInfo)
//                print(records.metaData.timeNow)
//
//            case let .failure(error):
//                print(error)
//            }
//        }
//          services.fetchBybitWalletRecords(currency: .BTC, pageNumber: 1) { result in
//              switch result {
//              case let .success(result):
//                  self.walletRecords = result
//                  guard
//                      let wallet = self.walletRecords
//                      else { return }
//                  print(wallet.records)
//                  print(wallet.metaData.returnCode)
//                  print(wallet.metaData.returnMessage)
//                  print(wallet.metaData.externalCodeError)
//                  print(wallet.metaData.exitInfo)
//                  print(wallet.metaData.timeNow)
//                  case let .failure(error):
//                      print(error)
//              }
//          }
//        services.fetchBybitAPIKeyInfo { result in
//            switch result {
//            case let .success(result):
//                self.apiKey = result
//                guard
//                    let key = self.apiKey
//                    else { return }
//                print(key.apiKey)
//                print(key.userID)
//                print(key.ipAddresses)
//                print(key.note)
//                print(key.permissions)
//                print(key.timeCreated)
//                print(key.isReadOnly)
//                print(key.metaData.returnCode)
//                print(key.metaData.returnMessage)
//                print(key.metaData.externalCodeError)
//                print(key.metaData.exitInfo)
//                print(key.metaData.timeNow)
//                case let .failure(error):
//                    print(error)
//            }
//        }
    }
}

