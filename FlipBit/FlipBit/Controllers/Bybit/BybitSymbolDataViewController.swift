//
//  BybitSymbolDataViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Starscream
import UIKit

class BybitSymbolDataViewController: ViewController, SocketObserverDelegate {
    
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
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leverageTapped)))
        container.isUserInteractionEnabled = false
        return container
    }()
    
    private lazy var currentLeverageLabel: UILabel = {
        let label = UILabel(font: UIFont.largeTitle, textColor: UIColor.Bybit.themeBlack)
        label.font = UIFont(name: "AvenirNext-Bold", size: 32.0)
        label.layer.cornerRadius = 14
        label.textAlignment = .center
        label.text = Constant.leverage
        return label
    }()
    
    private lazy var tradeView: TradeFlowView = {
        let view = TradeFlowView()
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
    
    private lazy var priceLabel: UILabel = {
        guard let font = UIFont(name: "AvenirNext-Bold", size: 28.0) else { return UILabel(text: Constant.price, font: UIFont.title3, textColor: UIColor.Bybit.themeBlack, textAlignment: .center) }
        return UILabel(text: Constant.price, font: font, textColor: UIColor.Bybit.themeBlack, textAlignment: .center)
    }()
    
    private lazy var pricePanel: Panel = {
        let container = Panel()
        container.setBybitTheme()
        container.addSubviews(views: [priceLabel])
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(priceTapped)))
        return container
    }()
    
    private lazy var quantityLabel: UILabel = {
        guard let font = UIFont(name: "AvenirNext-Bold", size: 28.0) else { return UILabel(text: Constant.quantity, font: UIFont.title3, textColor: UIColor.Bybit.themeBlack, textAlignment: .center) }
        return UILabel(text: Constant.quantity, font: font, textColor: UIColor.Bybit.themeBlack, textAlignment: .center)
    }()
    
    private lazy var quantityPanel: Panel = {
        let container = Panel()
        container.setBybitTheme()
        container.addSubviews(views: [quantityLabel])
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(quantityTapped)))
        return container
    }()
    
    private lazy var tradeHistoryContainer: View = {
        let container = View(backgroundColor: UIColor.Bybit.white)
        container.setBybitTheme()
        container.addSubview(view: tradeHistoryTable.view, constant: Dimensions.Space.margin4)
        return container
    }()
    
    private lazy var tradeHistoryTable: BybitTradeEventsTableViewController = {
        let tradeTable = BybitTradeEventsTableViewController()
        return tradeTable
    }()
    
    var leverageStatus: BitService.BybitLeverageStatus?
    var positions: BitService.BybitPositionList?
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .symbolObserverUpdate, object: nil)
        NotificationCenter.default.removeObserver(self, name: .buyBookObserverUpdate, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateSymbolInfo(notification:)), name: .symbolObserverUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateQuantityInfo(notification:)), name: .buyBookObserverUpdate, object: nil)
        services.fetchBybitLeverageStatus { result in
            switch result {
            case let .success(result):
                self.leverageStatus = result
                guard let leverage = self.leverageStatus else { return }
                self.currentLeverageLabel.text = "\(leverage.btcLeverage)x"
                self.leverageContainer.isUserInteractionEnabled = true
            case let.failure(error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        optionsViewGradient.frame = CGRect(x: .zero, y: .zero, width: tradeView.bounds.size.width, height: optionsViewGradientHeight)
    }
    
    override func setup() {
        super.setup()
        bookObserver.delegate = self
        symbolObserver.delegate = self
        tradeObserver.delegate = self
        view.backgroundColor = UIColor.Bybit.white
        //positionObserver.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissTextField)))
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        view.addSubview(symbolInfoView)
        view.addSubview(leverageContainer)
        view.addSubview(orderbookPanel)
        view.addSubview(pricePanel)
        view.addSubview(quantityPanel)
        view.addSubview(tradeHistoryContainer)
        view.addSubview(tradeView)
        
        orderbookPanel.setPriceSelector(selector: self)
        orderbookPanel.setQuantitySelector(selector: self)
        tradeView.configureButtons(self, action: #selector(tradeButtonTapped(sender:)))
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            
            symbolInfoView.topAnchor.constraint(equalTo: view.topAnchor),
            symbolInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            symbolInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            leverageContainer.topAnchor.constraint(equalTo: orderbookPanel.topAnchor),
            leverageContainer.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Dimensions.Space.margin8),
            leverageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin8),
            leverageContainer.bottomAnchor.constraint(equalTo: pricePanel.topAnchor, constant: -Dimensions.Space.margin10),
            
            pricePanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin8),
            pricePanel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Dimensions.Space.margin8),
            pricePanel.bottomAnchor.constraint(equalTo: quantityPanel.topAnchor, constant: -Dimensions.Space.margin10),
            
            quantityPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin8),
            quantityPanel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Dimensions.Space.margin8),
            
            orderbookPanel.topAnchor.constraint(equalTo: symbolInfoView.bottomAnchor, constant: Dimensions.Space.margin8),
            orderbookPanel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Dimensions.Space.margin8),
            orderbookPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin8),
            
            tradeHistoryContainer.topAnchor.constraint(equalTo: orderbookPanel.bottomAnchor, constant: Dimensions.Space.margin16),
            tradeHistoryContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin8),
            tradeHistoryContainer.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Dimensions.Space.margin8),
            tradeHistoryContainer.bottomAnchor.constraint(equalTo: tradeView.topAnchor, constant: -Dimensions.Space.margin10),
            
            tradeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tradeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tradeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Dimensions.Space.margin16)
        ])
    }
    
    func observer(observer: WebSocketDelegate, didWriteToSocket: String) {
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
    
    @objc func tradeButtonTapped(sender: UIButton) {
        hapticFeedback()
        guard
            let price = priceLabel.text,
            let quantity = quantityLabel.text,
            let buttonTitle = sender.titleLabel?.text
            else { return }
        
        let side = (buttonTitle == Constant.buy) ? Bybit.Side.Buy : Bybit.Side.Sell
        let order = Order(side: side, price: price, quantity: quantity)
        let vc = BybitTradeFlowViewController(order: order)
        present(vc, animated: true)
    }
    
    @objc func updateSymbolInfo(notification: NSNotification) {
        guard
            let newInfo = symbolObserver.symbolInfo,
            let price = newInfo.lastPrice
            else { return }
        priceLabel.text = price
        NotificationCenter.default.removeObserver(self, name: .symbolObserverUpdate, object: nil)
    }
    
    @objc func updateQuantityInfo(notification: NSNotification) {
        guard
            let firstBook = bookObserver.buyBook?.first,
            var size = firstBook?.size
            else { return }
        if size > 1000000 { size = 1000000 }
        quantityLabel.text = String(size)
        NotificationCenter.default.removeObserver(self, name: .buyBookObserverUpdate, object: nil)
    }
    
    @objc func leverageTapped() {
        guard let substring = currentLeverageLabel.text?.dropLast() else { return }
        hapticFeedback()
        let vc = BybitLeverageUpdateViewController(leverage: String(substring), observer: self)
        present(vc, animated: true)
    }
    
    @objc func priceTapped() {
        guard let price = priceLabel.text else { return }
        hapticFeedback()
        let vc = BybitPriceUpdateViewController(price: price, observer: self)
        present(vc, animated: true)
    }
    
    @objc func quantityTapped() {
        guard let quantity = quantityLabel.text else { return }
        hapticFeedback()
        let vc = BybitQuantityUpdateViewController(quantity: quantity, observer: self)
        present(vc, animated: true)
    }
    
    @objc func dismissTextField() {
        //        quantityStepper.textField.resignFirstResponder()
    }
}

extension BybitSymbolDataViewController: UITextFieldDelegate {
    
}

extension BybitSymbolDataViewController: PriceSelection {
    func priceSelected(price: String) {
        priceLabel.text = price
    }
}

extension BybitSymbolDataViewController: QuantitySelection {
    func quantitySelected(quantity: String) {
        quantityLabel.text = quantity
    }
}

extension BybitSymbolDataViewController: LeverageObserver {
    func leverageUpdated(leverage: String) {
        self.currentLeverageLabel.text = "\(leverage)x"
    }
}

extension BybitSymbolDataViewController: PriceObserver {
    func priceUpdated(price: String) {
        self.priceLabel.text = price
    }
}

extension BybitSymbolDataViewController: QuantityObserver {
    func quantityUpdated(quantity: String) {
        self.quantityLabel.text = quantity
    }
}
