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
    
    private lazy var symbolInfoView: SymbolInfoHeaderView = {
        let symbolInfoView = SymbolInfoHeaderView()
        symbolInfoView.configureView()
        return symbolInfoView
    }()

    private let orderbookPanel: OrderBookPanel = {
        OrderBookPanel()
    }()

    private lazy var leverageContainer: View = {
        let container = View(backgroundColor: UIColor.Bybit.white)
        container.setBybitTheme()
        container.addSubview(view: currentLeverageLabel, constant: 8)
        return container
    }()
    
    private lazy var currentLeverageLabel: UILabel = {
        let label = UILabel(font: UIFont.largeTitle, textColor: UIColor.Bybit.themeBlack)
        label.font = UIFont(name: "AvenirNext-Bold", size: 52.0)
        label.layer.cornerRadius = 14
        label.textAlignment = .center
        label.text = "   "
        return label
    }()
    
    private lazy var percentageContainer: PercentageView = {
        let percentageView = PercentageView()
        percentageView.configureButtonActions(viewController: self, action: #selector(addByPercentage(sender:)), event: .touchUpInside)
        return percentageView
    }()
        
    private lazy var longButton: UIButton = {
        let button = UIButton(type: .custom, title: Constant.long, textColor: UIColor.Bybit.white)
        button.titleLabel?.font = UIFont.body.bold
        button.backgroundColor = UIColor.flatMint
        button.layer.cornerRadius = 7.0
        return button
    }()
    
    private lazy var shortButton: UIButton = {
        let button = UIButton(type: .custom, title: Constant.short, textColor: UIColor.Bybit.white)
        button.titleLabel?.font = UIFont.body.bold
        button.backgroundColor = UIColor.flatWatermelon
        button.layer.cornerRadius = 7.0
        return button
    }()
    
    private lazy var orderPriceTitleLabel: UILabel = {
        let label = UILabel(font: UIFont.footnote, textColor: UIColor.Bybit.themeBlack)
        label.text = Constant.orderPrice
        return label
    }()
    
    private lazy var orderPriceLabel: UILabel = {
        let label = UILabel(font: UIFont.footnote, textColor: UIColor.Bybit.themeBlack)
        label.text = "7100"
        return label
    }()
    
    private lazy var orderQuantityTitleLabel: UILabel = {
        let label = UILabel(font: UIFont.footnote, textColor: UIColor.Bybit.themeBlack)
        label.text = Constant.orderQuantity
        return label
    }()
    
    private lazy var orderQuantityLabel: UILabel = {
        let label = UILabel(font: UIFont.footnote, textColor: UIColor.Bybit.themeBlack)
        label.text = "10000"
        return label
    }()
        
    private lazy var tradeHistoryContainer: View = {
        let container = View(backgroundColor: UIColor.Bybit.white)
        container.setBybitTheme()
        return container
    }()
    
    private lazy var tradeHistoryTable: BybitTradeEventsTableViewController = {
        let tradeTable = BybitTradeEventsTableViewController()
        return tradeTable
    }()

    var leverageStatus: BitService.BybitLeverageStatus?

    override func viewDidLoad() {
        super.viewDidLoad()
        services.fetchBybitLeverageStatus { result in
            switch result {

            case let .success(result):
                self.leverageStatus = result
                guard let leverage = self.leverageStatus else { return }
                self.currentLeverageLabel.text = "\(leverage.btcLeverage)x"
            case let.failure(error):
                print(result)
                print(error)
            }
        }
    }
    
    override func setup() {
        super.setup()
        bookObserver.delegate = self
        symbolObserver.delegate = self
        tradeObserver.delegate = self
        positionObserver.delegate = self
        view.backgroundColor = UIColor.Bybit.white
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        view.addSubview(symbolInfoView)
        view.addSubview(leverageContainer)
        view.addSubview(orderbookPanel)
        view.addSubview(percentageContainer)
        view.addSubview(orderPriceTitleLabel)
        view.addSubview(orderPriceLabel)
        view.addSubview(orderQuantityTitleLabel)
        view.addSubview(orderQuantityLabel)
        view.addSubview(longButton)
        view.addSubview(shortButton)
        view.addSubview(tradeHistoryContainer)
        
        tradeHistoryContainer.addSubview(tradeHistoryTable.view)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            
            symbolInfoView.topAnchor.constraint(equalTo: view.topAnchor),
            symbolInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            symbolInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            longButton.topAnchor.constraint(equalTo: orderbookPanel.topAnchor),
            longButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin8),
            longButton.trailingAnchor.constraint(equalTo: shortButton.leadingAnchor, constant: -Dimensions.Space.margin4),
            
            shortButton.topAnchor.constraint(equalTo: orderbookPanel.topAnchor),
            shortButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Dimensions.Space.margin8),
            shortButton.widthAnchor.constraint(equalTo: longButton.widthAnchor),
            
            leverageContainer.topAnchor.constraint(equalTo: shortButton.bottomAnchor, constant: Dimensions.Space.margin8),
            leverageContainer.centerXAnchor.constraint(equalTo: percentageContainer.centerXAnchor),
            
            orderPriceTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin8),
            orderPriceTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Dimensions.Space.margin8),
            orderPriceTitleLabel.bottomAnchor.constraint(equalTo: orderbookPanel.centerYAnchor, constant: -Dimensions.Space.margin16),
            
            orderPriceLabel.leadingAnchor.constraint(equalTo: orderPriceTitleLabel.leadingAnchor),
            orderPriceLabel.trailingAnchor.constraint(equalTo: orderPriceTitleLabel.trailingAnchor),
            orderPriceLabel.topAnchor.constraint(equalTo: orderPriceTitleLabel.bottomAnchor),
            
            orderQuantityTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin8),
            orderQuantityTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Dimensions.Space.margin8),
            orderQuantityTitleLabel.topAnchor.constraint(equalTo: orderbookPanel.centerYAnchor, constant: Dimensions.Space.margin16),
            orderQuantityLabel.leadingAnchor.constraint(equalTo: orderQuantityTitleLabel.leadingAnchor),
            orderQuantityLabel.trailingAnchor.constraint(equalTo: orderQuantityTitleLabel.trailingAnchor),
            orderQuantityLabel.topAnchor.constraint(equalTo: orderQuantityTitleLabel.bottomAnchor),
            
            orderbookPanel.topAnchor.constraint(equalTo: symbolInfoView.bottomAnchor, constant: Dimensions.Space.margin24),
            orderbookPanel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Dimensions.Space.margin8),
            orderbookPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin8),

            percentageContainer.bottomAnchor.constraint(equalTo: orderbookPanel.bottomAnchor),
            percentageContainer.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Dimensions.Space.margin8),
            percentageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin8),
            
            tradeHistoryContainer.topAnchor.constraint(equalTo: orderbookPanel.bottomAnchor, constant: Dimensions.Space.margin16),
            tradeHistoryContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin8),
            tradeHistoryContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin8),
            tradeHistoryContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Dimensions.Space.margin8),
            
            tradeHistoryTable.view.topAnchor.constraint(equalTo: tradeHistoryContainer.topAnchor, constant: Dimensions.Space.margin4),
            tradeHistoryTable.view.bottomAnchor.constraint(equalTo: tradeHistoryContainer.bottomAnchor, constant: -Dimensions.Space.margin4),
            tradeHistoryTable.view.leadingAnchor.constraint(equalTo: tradeHistoryContainer.leadingAnchor, constant: Dimensions.Space.margin4),
            tradeHistoryTable.view.trailingAnchor.constraint(equalTo: tradeHistoryContainer.trailingAnchor, constant: -Dimensions.Space.margin4)
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
    }
    
    func observerDidReceiveMessage(observer: WebSocketDelegate) {
    }
    
    func observerFailedToDecode(observer: WebSocketDelegate) {
        print("Observer failed to decode the response from the web socket")
    }
    
    @objc func addByPercentage(sender: UIButton) {
        print(sender.titleLabel?.text as Any)
    }
}
