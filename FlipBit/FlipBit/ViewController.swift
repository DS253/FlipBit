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
    typealias BitServiceOrderbookLookupCompletion = (Result<BitService.BybitOrderbook, BitService.Error>) -> Void
    typealias BitServicePositionLookupCompletion = (Result<BitService.BybitPositionList, BitService.Error>) -> Void
    typealias BitServicePredictedFundingLookupCompletion = (Result<BitService.BybitPredictedFunding, BitService.Error>) -> Void
    typealias BitServicePreviousFundingLookupCompletion = (Result<BitService.BybitPreviousFundingFee, BitService.Error>) -> Void
    typealias BitServicePreviousFundingRateLookupCompletion = (Result<BitService.BybitPreviousFundingRate, BitService.Error>) -> Void
    typealias BitServiceServerTimeLookupCompletion = (Result<BitService.BybitServerTime, BitService.Error>) -> Void
    typealias BitServiceTickersLookupCompletion = (Result<BitService.BybitTickers, BitService.Error>) -> Void
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

    var withdrawRecords: BitService.BybitWithdrawalRecords?
    
    @IBOutlet weak var executeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func executeAction() {
        services.api.cancelAllSessionTasks()
        services.fetchBybitWithdrawRecords(currency: .BTC, pageNumber: 1) { result in
            switch result {
            case let .success(result):
                self.withdrawRecords = result
                guard
                    let records = self.withdrawRecords
                    else { return }
                print(records)
                print(records.metaData.returnCode)
                print(records.metaData.returnMessage)
                print(records.metaData.externalCodeError)
                print(records.metaData.exitInfo)
                print(records.metaData.timeNow)

            case let .failure(error):
                print(error)
            }
        }
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
        
//        services.fetchBybitPreviousFundingRate(symbol: .BTC) { result in
//            switch result {
//            case let .success(result):
//                self.previousRate = result
//                print(self.previousRate)
//
//            case let .failure(error):
//                print(error)
//            }
//        }
        
//        services.fetchBybitPosition { result in
//            switch result {
//            case let .success(result):
//                self.position = result
//                print(self.position)
//
//            case let .failure(error):
//                print(error)
//            }
//        }
        
//        services.fetchBybitTradeRecords(symbol: .BTC, pageNumber: 1) { result in
//            switch result {
//            case let .success(result):
//                self.tradeRecords = result
//                print(self.tradeRecords)
//
//            case let .failure(error):
//                print(error)
//            }
//        }
//        services.fetchBybitWithdrawRecords(currency: .BTC, pageNumber: 1) { result in
//            switch result {
//            case let .success(result):
//                self.walletRecords = result
//                print(self.walletRecords)
//
//            case let .failure(error):
//                print(error)
//            }
//        }

//        services.fetchBybitPreviousFunding(symbol: .BTC) { result in
//            switch result {
//            case let .success(result):
//                self.previousFunding = result
//                print(self.previousFunding)
//
//            case let .failure(error):
//                print(error)
//            }
//        }
//        services.fetchBybitPredictedFunding(symbol: .BTC) { result in
//            switch result {
//            case let .success(result):
//                self.funding = result
//                print(self.funding)
//
//            case let .failure(error):
//                print(error)
//            }
//        }
        
//        services.fetchBybitTickers(symbol: .BTC) { result in
//            switch result {
//            case let .success(result):
//                self.tickers = result
//                print(self.tickers)
//
//            case let .failure(error):
//                print(error)
//            }
//        }
//        services.fetchBybitServerTime { result in
//            switch result {
//            case let .success(result):
//                self.time = result
//                print(self.time)
//                guard let op = self.time else { return }
//                let seconds = Double(op.time)
//                print(seconds?.convertSecondsToDate())
//
//            case let .failure(error):
//                print(error)
//            }
//        }
//        services.fetchBybitOrderBook(symbol: .XRP) { result in
//            switch result {
//                case let .success(result):
//                    self.orderbook = result
//                    print(self.orderbook)
//                case let .failure(error):
//                    print(error)
//            }
//        }
    }
}

