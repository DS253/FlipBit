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
    typealias BitServicePredictedFundingLookupCompletion = (Result<BitService.BybitPredictedFunding, BitService.Error>) -> Void
    typealias BitServiceServerTimeLookupCompletion = (Result<BitService.BybitServerTime, BitService.Error>) -> Void
    typealias BitServiceTickersLookupCompletion = (Result<BitService.BybitTickers, BitService.Error>) -> Void
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
    
    func fetchBybitPredictedFunding(symbol: BitService.BybitSymbol, completion: @escaping BitServicePredictedFundingLookupCompletion) {
        bitService.lookupBybitPredictedFunding(symbol: symbol, completion: completion)
    }
    
    func fetchBybitServerTime(completion: @escaping BitServiceServerTimeLookupCompletion) {
        bitService.lookupBybitServerTime(completion: completion)
    }
    
    func fetchBybitTickers(symbol: BitService.BybitSymbol, completion: @escaping BitServiceTickersLookupCompletion) {
        bitService.lookupBybitTickers(symbol: symbol, completion: completion)
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

    var funding: BitService.BybitPredictedFunding?
    
    @IBOutlet weak var executeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func executeAction() {
        services.api.cancelAllSessionTasks()
        services.fetchBybitPredictedFunding(symbol: .BTC) { result in
            switch result {
            case let .success(result):
                self.funding = result
                print(self.funding)
                
            case let .failure(error):
                print(error)
            }
        }
        
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
//        services.fetchBybitAPIKeyInfo { result in
//            switch result {
//                case let .success(result):
//                    self.apiKey = result
//                    print(self.apiKey)
//                case let .failure(error):
//                    print(error)
//            }
//        }
    }
}

