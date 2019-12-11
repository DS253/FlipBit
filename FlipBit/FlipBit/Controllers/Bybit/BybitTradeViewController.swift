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

    private lazy var optionView: View = {
        let view = View()
        view.backgroundColor = UIColor.Bybit.white
        return view
    }()

    private lazy var optionsViewGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.flatNavyBlue.withAlphaComponent(0.45).cgColor,
            UIColor.flatNavyBlue.withAlphaComponent(0.0).cgColor
        ]

        return gradient
    }()

    private let optionsViewGradientHeight: CGFloat = 4.0
    
    private lazy var pricePickerView: ValuePickerView = {
        ValuePickerView(title: Constant.orderPrice, value: "7100")
    }()
    
    private lazy var quantityPickerView: ValuePickerView = {
        ValuePickerView(title: Constant.orderQuantity, value: "10000")
    }()
    
    private lazy var tradeHistoryContainer: View = {
        let container = View(backgroundColor: UIColor.Bybit.white)
        container.setBybitTheme()
        container.layer.shadowOpacity = 0
        container.addSubview(view: tradeHistoryTable.view, constant: Dimensions.Space.margin4)
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        optionsViewGradient.frame = CGRect(x: .zero, y: .zero, width: optionView.bounds.size.width, height: optionsViewGradientHeight)
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
        view.addSubview(pricePickerView)
        view.addSubview(quantityPickerView)
        view.addSubview(tradeHistoryContainer)
        view.addSubview(optionView)

        optionView.addSublayer(optionsViewGradient)
        optionView.addSubview(longButton)
        optionView.addSubview(shortButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            
            symbolInfoView.topAnchor.constraint(equalTo: view.topAnchor),
            symbolInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            symbolInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            leverageContainer.topAnchor.constraint(equalTo: orderbookPanel.topAnchor),
            leverageContainer.centerXAnchor.constraint(equalTo: percentageContainer.centerXAnchor),
            
            pricePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin8),
            pricePickerView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Dimensions.Space.margin8),
            pricePickerView.bottomAnchor.constraint(equalTo: quantityPickerView.topAnchor, constant: -Dimensions.Space.margin8),
            
            quantityPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin8),
            quantityPickerView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Dimensions.Space.margin8),
            quantityPickerView.bottomAnchor.constraint(equalTo: percentageContainer.topAnchor, constant: -Dimensions.Space.margin16),
            
            orderbookPanel.topAnchor.constraint(equalTo: symbolInfoView.bottomAnchor, constant: Dimensions.Space.margin24),
            orderbookPanel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Dimensions.Space.margin8),
            orderbookPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin8),
            
            percentageContainer.bottomAnchor.constraint(equalTo: orderbookPanel.bottomAnchor),
            percentageContainer.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Dimensions.Space.margin8),
            percentageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin8),
            
            tradeHistoryContainer.topAnchor.constraint(equalTo: orderbookPanel.bottomAnchor, constant: Dimensions.Space.margin16),
            tradeHistoryContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin8),
            tradeHistoryContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin8),
            tradeHistoryContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Dimensions.Space.margin8),

            shortButton.topAnchor.constraint(equalTo: optionView.topAnchor, constant: Dimensions.Space.margin8),
            shortButton.bottomAnchor.constraint(equalTo: optionView.bottomAnchor, constant: -Dimensions.Space.margin8),
            shortButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin8),
            shortButton.trailingAnchor.constraint(equalTo: longButton.leadingAnchor, constant: -Dimensions.Space.margin4),
            shortButton.heightAnchor.constraint(equalToConstant: Dimensions.Space.margin48),

            longButton.topAnchor.constraint(equalTo: optionView.topAnchor, constant: Dimensions.Space.margin8),
            longButton.trailingAnchor.constraint(equalTo: optionView.trailingAnchor, constant: -Dimensions.Space.margin8),
            longButton.bottomAnchor.constraint(equalTo: optionView.bottomAnchor, constant: -Dimensions.Space.margin8),
            longButton.heightAnchor.constraint(equalToConstant: Dimensions.Space.margin48),
            longButton.widthAnchor.constraint(equalTo: shortButton.widthAnchor),

            optionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            optionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            optionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Dimensions.Space.margin16)
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
