//
//  BybitTradeViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/21/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Starscream
import UIKit

class BybitTradeViewController: ViewController, SocketObserverDelegate {
    
    private let orderbookContainer: View = {
        let container = View()
        container.backgroundColor = .white
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
        view.backgroundColor = .white
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        view.addSubview(orderbookContainer)
        orderbookContainer.addSubview(buybook.view)
        orderbookContainer.addSubview(sellbook.view)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            orderbookContainer.topAnchor.constraint(equalTo: view.topAnchor),
            orderbookContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            orderbookContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            orderbookContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buybook.view.topAnchor.constraint(equalTo: orderbookContainer.topAnchor),
            buybook.view.bottomAnchor.constraint(equalTo: orderbookContainer.bottomAnchor),
            buybook.view.leadingAnchor.constraint(equalTo: orderbookContainer.leadingAnchor),
            buybook.view.trailingAnchor.constraint(equalTo: orderbookContainer.centerXAnchor),
            
            sellbook.view.topAnchor.constraint(equalTo: orderbookContainer.topAnchor),
            sellbook.view.bottomAnchor.constraint(equalTo: orderbookContainer.bottomAnchor),
            sellbook.view.leadingAnchor.constraint(equalTo: orderbookContainer.centerXAnchor),
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
    }
    
    func observerDidReceiveMessage(observer: WebSocketDelegate) {
//        print("Observer has received messages from the web socket")
    }
    
    func observerFailedToDecode(observer: WebSocketDelegate) {
        print("Observer failed to decode the response from the web socket")
    }
}
