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
    
    private lazy var buybook: BuyOrderBookView = {
        BuyOrderBookView()
    }()
    
    private lazy var sellbook: SellOrderBookView = {
        let sellView = SellOrderBookView()
        sellView.configureViewForSellBook()
        return sellView
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
        orderbookContainer.addSubview(buybook)
        orderbookContainer.addSubview(sellbook)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            
            symbolInfoView.topAnchor.constraint(equalTo: view.topAnchor),
            symbolInfoView.bottomAnchor.constraint(equalTo: orderbookContainer.topAnchor),
            symbolInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            symbolInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            orderbookContainer.topAnchor.constraint(equalTo: symbolInfoView.bottomAnchor),
            orderbookContainer.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            orderbookContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buybook.topAnchor.constraint(equalTo: orderbookContainer.topAnchor),
            buybook.bottomAnchor.constraint(equalTo: orderbookContainer.centerYAnchor),
            buybook.leadingAnchor.constraint(equalTo: orderbookContainer.leadingAnchor),
            buybook.trailingAnchor.constraint(equalTo: orderbookContainer.trailingAnchor),

            sellbook.topAnchor.constraint(equalTo: orderbookContainer.centerYAnchor),
            sellbook.bottomAnchor.constraint(equalTo: orderbookContainer.bottomAnchor),
            sellbook.leadingAnchor.constraint(equalTo: orderbookContainer.leadingAnchor),
            sellbook.trailingAnchor.constraint(equalTo: orderbookContainer.trailingAnchor)
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
