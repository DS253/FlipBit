//
//  BybitTradeViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/21/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Starscream
import UIKit

protocol BybitSymbolObserver: class {
    func observerUpdatedSymbol()
}

class BybitTradeViewController: ViewController, SocketObserverDelegate {
    
    private lazy var symbolInfoView: SymbolInfoHeaderView = {
        let symbolInfoView = SymbolInfoHeaderView()
        symbolInfoView.configureView()
        return symbolInfoView
    }()
    
    private let orderbookContainer: View = {
        let container = View()
        container.backgroundColor = UIColor.Bybit.themeBlack
        return container
    }()
    
    private lazy var buybook: BybitBuyTableViewController = {
        let buybook = BybitBuyTableViewController()
        buybook.view.translatesAutoresizingMaskIntoConstraints = false
        return buybook
    }()
    
    private lazy var sellbook: BybitSellTableViewController = {
        let sellbook = BybitSellTableViewController()
        sellbook.view.translatesAutoresizingMaskIntoConstraints = false
        return sellbook
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setup() {
        super.setup()
        bookObserver.delegate = self
        symbolObserver.delegate = self
        view.backgroundColor = UIColor.Bybit.themeBlack
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        view.addSubview(symbolInfoView)
        view.addSubview(orderbookContainer)
        orderbookContainer.addSubview(buybook.view)
        orderbookContainer.addSubview(sellbook.view)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            
            symbolInfoView.topAnchor.constraint(equalTo: view.topAnchor),
            symbolInfoView.bottomAnchor.constraint(equalTo: orderbookContainer.topAnchor),
            symbolInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            symbolInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            orderbookContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            orderbookContainer.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            orderbookContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buybook.view.topAnchor.constraint(equalTo: orderbookContainer.topAnchor),
            buybook.view.bottomAnchor.constraint(equalTo: orderbookContainer.centerYAnchor),
            buybook.view.leadingAnchor.constraint(equalTo: orderbookContainer.leadingAnchor),
            buybook.view.trailingAnchor.constraint(equalTo: orderbookContainer.trailingAnchor),

            sellbook.view.topAnchor.constraint(equalTo: orderbookContainer.centerYAnchor),
            sellbook.view.bottomAnchor.constraint(equalTo: orderbookContainer.bottomAnchor),
            sellbook.view.leadingAnchor.constraint(equalTo: orderbookContainer.leadingAnchor),
            sellbook.view.trailingAnchor.constraint(equalTo: orderbookContainer.trailingAnchor)
        ])
    }
        
    func observer(observer: WebSocketDelegate, didWriteToSocket: String) {
        print("Observer has written to the web socket")
    }
    
    func observerFailedToConnect() {
        print("Observer has failed to connect to the web socket")
    }
    
    func observerDidConnect(observer: WebSocketDelegate) {
        print("Observer has connected to the web socket")
        bookObserver.writeToSocket(topic: "{\"op\": \"subscribe\", \"args\": [\"orderBookL2_25.BTCUSD\"]}")
        symbolObserver.writeToSocket(topic: "{\"op\": \"subscribe\", \"args\": [\"instrument_info.100ms.BTCUSD\"]}")
    }
    
    func observerDidReceiveMessage(observer: WebSocketDelegate) {
//        print("Observer has received messages from the web socket")
    }
    
    func observerFailedToDecode(observer: WebSocketDelegate) {
        print("Observer failed to decode the response from the web socket")
    }
}
