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
    typealias BybitAPIKeyInfo = BitService.BybitAPIKeyInfo
    
    let api: Service = {
        Service(sessionConfiguration: Service.NetSessionConfiguration())
    }()
    
    let bitService: BitService = BitService()
    
    func fetchBybitAPIKeyInfo(completion: @escaping BitServiceAPILookupCompletion) {
        bitService.lookupAPIKeyInfo(completion: completion)
    }
    
    func fetchBybitOrderBook(symbol: BitService.BybitSymbol, completion: @escaping BitServiceOrderbookLookupCompletion) {
        bitService.lookupOrderBook(symbol: symbol, completion: completion)
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

    var orderbook: BitService.BybitOrderbook?
    
    @IBOutlet weak var executeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func executeAction() {
        services.api.cancelAllSessionTasks()
        services.fetchBybitOrderBook(symbol: .XRP) { result in
            switch result {
                case let .success(result):
                    self.orderbook = result
                    print(self.orderbook)
                case let .failure(error):
                    print(error)
            }
        }
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

