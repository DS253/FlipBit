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
        
    private let buybookContainer: View = {
        let container = View()
        container.backgroundColor = UIColor.Bybit.themeBlack
        container.setBybitTheme()
        return container
    }()
    
    private let sellbookContainer: View = {
        let container = View()
        container.backgroundColor = UIColor.Bybit.themeBlack
        container.setBybitTheme()
        return container
    }()
    
    private let percentageContainer: View = {
        let container = View()
        container.backgroundColor = UIColor.Bybit.themeBlack
        container.setBybitTheme()
        return container
    }()
    
    private lazy var buybook: BuyOrderBookView = {
        let buyView = BuyOrderBookView()
        buyView.layer.cornerRadius = 7
        buyView.layer.masksToBounds = true
        buyView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        return buyView
    }()
    
    private lazy var sellbook: SellOrderBookView = {
        let sellView = SellOrderBookView()
        sellView.configureViewForSellBook()
        sellView.layer.cornerRadius = 7
        sellView.layer.masksToBounds = true
        sellView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        return sellView
    }()
    
    private lazy var button25: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("25%", for: .normal)
        button.setTitleColor(UIColor.Bybit.white, for: .normal)
        button.addTarget(self, action: #selector(addByPercentage(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var button50: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("50%", for: .normal)
        button.setTitleColor(UIColor.Bybit.white, for: .normal)
        button.addTarget(self, action: #selector(addByPercentage(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var button75: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("75%", for: .normal)
        button.setTitleColor(UIColor.Bybit.white, for: .normal)
        button.addTarget(self, action: #selector(addByPercentage(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var button100: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("100%", for: .normal)
        button.setTitleColor(UIColor.Bybit.white, for: .normal)
        button.addTarget(self, action: #selector(addByPercentage(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        view.addSubview(buybookContainer)
        view.addSubview(percentageContainer)
        buybookContainer.addSubview(buybook)
        view.addSubview(sellbookContainer)
        sellbookContainer.addSubview(sellbook)
        percentageContainer.addSubview(button25)
        percentageContainer.addSubview(button50)
        percentageContainer.addSubview(button75)
        percentageContainer.addSubview(button100)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            
            symbolInfoView.topAnchor.constraint(equalTo: view.topAnchor),
            symbolInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            symbolInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buybookContainer.topAnchor.constraint(equalTo: symbolInfoView.bottomAnchor, constant: Dimensions.Space.margin32),
            buybookContainer.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Dimensions.Space.margin8),
            buybookContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin8),
            
            sellbookContainer.topAnchor.constraint(equalTo: buybookContainer.bottomAnchor, constant: Dimensions.Space.margin16),
            sellbookContainer.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Dimensions.Space.margin8),
            sellbookContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin8),
            
            percentageContainer.topAnchor.constraint(equalTo: symbolInfoView.bottomAnchor, constant: Dimensions.Space.margin32),
            percentageContainer.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Dimensions.Space.margin8),
            percentageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin8),
            
            buybook.topAnchor.constraint(equalTo: buybookContainer.topAnchor, constant: Dimensions.Space.margin16),
            buybook.bottomAnchor.constraint(equalTo: buybookContainer.bottomAnchor, constant: -Dimensions.Space.margin16),
            buybook.leadingAnchor.constraint(equalTo: buybookContainer.leadingAnchor, constant: Dimensions.Space.margin16),
            buybook.trailingAnchor.constraint(equalTo: buybookContainer.trailingAnchor, constant: -Dimensions.Space.margin16),

            sellbook.topAnchor.constraint(equalTo: sellbookContainer.topAnchor, constant: Dimensions.Space.margin16),
            sellbook.bottomAnchor.constraint(equalTo: sellbookContainer.bottomAnchor, constant: -Dimensions.Space.margin16),
            sellbook.leadingAnchor.constraint(equalTo: sellbookContainer.leadingAnchor, constant: Dimensions.Space.margin16),
            sellbook.trailingAnchor.constraint(equalTo: sellbookContainer.trailingAnchor, constant: -Dimensions.Space.margin16),
            
            button25.topAnchor.constraint(equalTo: percentageContainer.topAnchor, constant: Dimensions.Space.margin4),
            button25.bottomAnchor.constraint(equalTo: percentageContainer.bottomAnchor, constant: -Dimensions.Space.margin4),
            button25.leadingAnchor.constraint(equalTo: percentageContainer.leadingAnchor, constant: Dimensions.Space.margin4),
            button25.trailingAnchor.constraint(equalTo: button50.leadingAnchor),
            
            button50.topAnchor.constraint(equalTo: percentageContainer.topAnchor, constant: Dimensions.Space.margin4),
            button50.bottomAnchor.constraint(equalTo: percentageContainer.bottomAnchor, constant: -Dimensions.Space.margin4),
            button50.widthAnchor.constraint(equalTo: button25.widthAnchor),
            button50.trailingAnchor.constraint(equalTo: button75.leadingAnchor),
            
            button75.topAnchor.constraint(equalTo: percentageContainer.topAnchor, constant: Dimensions.Space.margin4),
            button75.bottomAnchor.constraint(equalTo: percentageContainer.bottomAnchor, constant: -Dimensions.Space.margin4),
            button75.widthAnchor.constraint(equalTo: button25.widthAnchor),
            button75.trailingAnchor.constraint(equalTo: button100.leadingAnchor),
            
            button100.topAnchor.constraint(equalTo: percentageContainer.topAnchor, constant: Dimensions.Space.margin4),
            button100.bottomAnchor.constraint(equalTo: percentageContainer.bottomAnchor, constant: -Dimensions.Space.margin4),
            button100.widthAnchor.constraint(equalTo: button25.widthAnchor),
            button100.trailingAnchor.constraint(equalTo: percentageContainer.trailingAnchor, constant: -Dimensions.Space.margin4)
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
//        symbolObserver.writeToSocket(topic: "{\"op\":\"subscribe\",\"args\":[\"trade.BTCUSD\"]}")
        symbolObserver.writeToSocket(topic: "{\"op\": \"subscribe\", \"args\": [\"instrument_info.100ms.BTCUSD\"]}")
    }
    
    func observerDidReceiveMessage(observer: WebSocketDelegate) {
//        print("Observer has received messages from the web socket")
    }
    
    func observerFailedToDecode(observer: WebSocketDelegate) {
        print("Observer failed to decode the response from the web socket")
    }
    
    @objc func addByPercentage(sender: UIButton) {
        print(sender.titleLabel?.text)
    }
}
