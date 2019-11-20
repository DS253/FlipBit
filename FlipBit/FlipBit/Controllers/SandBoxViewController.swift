//
//  SandBoxViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt
import Starscream
import UIKit

class SandBoxViewController: ViewController, WebSocketDelegate {
    var socket: WebSocket!
    
    private lazy var executeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Execute", for: .normal)
        button.addTarget(self, action: #selector(executeAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var request = URLRequest(url: URL(string: "wss://stream.bybit.com/realtime")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    override func setup() {
        super.setup()
        view.backgroundColor = .white
    }

    override func setupSubviews() {
        view.addSubview(executeButton)
    }

    override func setupConstraints() {
        executeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        executeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        executeButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        executeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
     // MARK: Websocket Delegate Methods.
     
     func websocketDidConnect(socket: WebSocketClient) {
         print("websocket is connected")
     }
     
     func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
         if let e = error as? WSError {
             print("websocket is disconnected: \(e.message)")
         } else if let e = error {
             print("websocket is disconnected: \(e.localizedDescription)")
         } else {
              print("websocket disconnected")
         }
     }
     
     func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
         //print("Received text: \(text)")
         
         guard
             let data = text.data(using: String.Encoding.utf8)
             else {
                 print("NOOOOOO")
                 return
         }
         
         guard
         let anyobject = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)),
             let dictionary = anyobject as? Dictionary<String, Any>
             else { return }
         
         if (dictionary["data"] as? [Dictionary<String, Any>]) != nil {
             let snapshot = dictionary.parseSnapshot()
             print("Topic: \(snapshot.topic)")
             print("Type: \(snapshot.type)")
             print("Timestamp: \(snapshot.timestamp)")
             print("CrossSequence: \(snapshot.crossSequence)")
             print(snapshot.book)
         } else if (dictionary["data"] as? Dictionary<String, Any>) != nil {
             let update = dictionary.parseBookUpdate()
             print("Topic: \(update.topic)")
             print("Type: \(update.type)")
             print("TransactionTime: \(update.transactionTime)")
             print("CrossSequence: \(update.crossSequence)")
             print("Deletes: \(update.deletes)")
             print("Updates: \(update.updates)")
             print("Inserts: \(update.inserts)")
         }
         
         if dictionary.keys.contains("success") {
             let response = parseSocketResponse(dictionary: dictionary)
             print("Success: \(response.success)")
             print("Message: \(response.message)")
             print("Connection ID: \(response.connectionID)")
             print("Operations: \(response.operation)")
             print("Arguments: \(response.arguments)")
         }
     }
     
     struct SocketResponse {
         var success: Bool?
         var message: String?
         var connectionID: String?
         var operation: String?
         var arguments: [String]?
     }
         
     func parseSocketResponse(dictionary: Dictionary<String, Any>) -> SocketResponse {

         var response = SocketResponse()
         response.success = dictionary["success"] as? Bool
         response.message = dictionary["ret_msg"] as? String
         response.connectionID = dictionary["conn_id"] as? String
         guard
             let request = dictionary["request"] as? [String: Any]
             else { return response }
         response.operation = request["op"] as? String
         response.arguments = request["args"] as? [String]

         return response
     }
     
     func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
         print("Received data: \(data.count)")
     }
     
     // MARK: Write Text Action
     
    @objc func executeAction() {
    //     socket.write(string: "hello there!")
         socket.write(string: "{\"op\": \"subscribe\", \"args\": [\"orderBookL2_25.BTCUSD\"]}")
     }
}
    
//class SandBoxViewController: ViewController {
//
//    var leverageStatus: BitService.BybitLeverageStatus?
//    var leverageUpdate: BitService.BybitLeverageUpdate?
//    var updateOrderResponse: BitService.BybitActiveOrderUpdate?
//    var cancelOrderResponse: BitService.BybitCancelledOrder?
//    var previousFunding: BitService.BybitPreviousFundingFee?
//    var orderResponse: BitService.BybitOrderResponse?
//    var orderList: BitService.BybitActiveOrderList?
//
//    private lazy var executeButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Execute", for: .normal)
//        button.addTarget(self, action: #selector(executeAction), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    override func setup() {
//        super.setup()
//        view.backgroundColor = .white
//    }
//
//    override func setupSubviews() {
//        view.addSubview(executeButton)
//    }
//
//    override func setupConstraints() {
//        executeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        executeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        executeButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        executeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    }
//
//    @objc func executeAction() {
//        services.api.cancelAllSessionTasks()
//
//        services.updateBybitLeverage(symbol: .BTC, leverage: "10") { result in
//            switch result {
//            case let .success(result):
//                self.leverageUpdate = result
//                guard let leverage = self.leverageUpdate else { return }
//                print(leverage.metaData)
//            case let.failure(error):
//                print(error)
//            }
//
//        }
//        services.fetchBybitLeverageStatus { result in
//            switch result {
//            case let .success(result):
//                self.leverageStatus = result
//                guard let leverage = self.leverageStatus else { return }
//                print(leverage.btcLeverage)
//                print(leverage.ethLeverage)
//                print(leverage.eosLeverage)
//                print(leverage.xrpLeverage)
//                print(leverage.metaData)
//            case let.failure(error):
//                print(error)
//            }
//
//        }
//        services.updateBybitActiveOrder(orderID: "35ef0ac0-7014-4050-ad1a-c93276d0f7cd", symbol: .BTC, quantity: 9000, price: 500) { result in
//            switch result {
//            case let .success(result):
//                self.updateOrderResponse = result
//                guard let order = self.updateOrderResponse else { return }
//                print(order.metaData)
//            case let .failure(error):
//                print(error)
//            }
//
//        }
//
//        services.cancelBybitActiveOrder(orderLinkID: "lsdflsfdlsdf") { result in
//            switch result {
//            case let .success(result):
//                self.cancelOrderResponse = result
//                guard let order = self.cancelOrderResponse else { return }
//                print(order.details)
//                print(order.lastExecutionPrice)
//                print(order.lastExecutionTime)
//                print(order.totalExecutionFee)
//                print(order.totalExecutionValue)
//            case let .failure(error):
//                print(error)
//            }
//
//        }
//        services.fetchBybitActiveOrderList(symbol: .BTC, pageNumber: 1) { result in
//            switch result {
//            case let .success(result):
//                self.orderList = result
//                guard let order = self.orderList else { return }
//                print(order.activeOrders)
//            case let .failure(error):
//                print(error)
//            }
//
//        }
//        services.createBybitActiveOrder(side: .Buy, symbol: .BTC, orderType: .Limit, quantity: 10000, timeInForce: .GoodTillCancel, price: 7000) { result in
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
//
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
//    }
//}
//
