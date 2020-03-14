//
//  BybitSymbolDataViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Starscream
import UIKit

class BybitSymbolDataViewController: FlipBitCollectionViewController, SocketObserverDelegate {
    
    private lazy var symbolInfoView: SymbolInfoHeaderView = {
        SymbolInfoHeaderView()
    }()
    
    private let orderbookPanel: OrderBookPanel = {
        OrderBookPanel()
    }()
    
    private lazy var leverageContainer: View = {
        let container = View(backgroundColor: themeManager.themeBackgroundColor, interactive: false)
        container.setBybitTheme()
        container.addSubview(view: currentLeverageLabel, constant: 8)
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leverageTapped)))
        return container
    }()
    
    /// Displays the current set leverage.
    private lazy var currentLeverageLabel: UILabel = {
        let font = UIFont(name: "AvenirNext-Bold", size: 32.0)
        let label = UILabel(text: Constant.leverage, font: font, textColor: themeManager.themeFontColor, textAlignment: .center)
        label.layer.cornerRadius = 14
        return label
    }()
    
    private lazy var tradeView: TradeFlowView = {
        TradeFlowView()
    }()
    
    private lazy var optionsViewGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.flatNavyBlue.withAlphaComponent(0.45).cgColor, UIColor.flatNavyBlue.withAlphaComponent(0.0).cgColor]
        return gradient
    }()
    /// Displays the current set price.
    private lazy var priceLabel: UILabel = {
        let font = UIFont(name: "AvenirNext-Bold", size: 28.0)
        return UILabel(text: Constant.price, font: font, textColor: themeManager.themeFontColor, textAlignment: .center)
    }()
    
    private lazy var pricePanel: Panel = {
        let container = Panel()
        container.addSubviews(views: [priceLabel])
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(priceTapped)))
        return container
    }()
    /// Displays the current set quantity.
    private lazy var quantityLabel: UILabel = {
        let font = UIFont(name: "AvenirNext-Bold", size: 28.0)
        return UILabel(text: Constant.quantity, font: font, textColor: themeManager.themeFontColor, textAlignment: .center)
    }()
    
    private lazy var quantityPanel: Panel = {
        let container = Panel()
        container.addSubviews(views: [quantityLabel])
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(quantityTapped)))
        return container
    }()
    
    private lazy var tradeHistoryContainer: View = {
        let container = View(backgroundColor: themeManager.themeBackgroundColor)
        container.setBybitTheme()
        container.addSubview(view: tradeHistoryTable.view, constant: Space.margin4)
        return container
    }()
    
    private lazy var tradeHistoryTable: BybitTradeEventsTableViewController = {
        BybitTradeEventsTableViewController()
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
        optionsViewGradient.frame = CGRect(x: .zero, y: .zero, width: tradeView.bounds.size.width, height: Space.margin4)
    }
    
    override func setup() {
        super.setup()
        bookObserver.delegate = self
        symbolObserver.delegate = self
        tradeObserver.delegate = self
        view.backgroundColor = themeManager.themeBackgroundColor
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        //positionObserver.delegate = self
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
        
        collectionView.isHidden = true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
                NSLayoutConstraint.activate([
        
                    symbolInfoView.topAnchor.constraint(equalTo: view.topAnchor),
                    symbolInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    symbolInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
                    leverageContainer.topAnchor.constraint(equalTo: orderbookPanel.topAnchor),
                    leverageContainer.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Space.margin8),
                    leverageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.margin8),
                    leverageContainer.bottomAnchor.constraint(equalTo: pricePanel.topAnchor, constant: -Space.margin10),
        
                    pricePanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.margin8),
                    pricePanel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Space.margin8),
                    pricePanel.bottomAnchor.constraint(equalTo: quantityPanel.topAnchor, constant: -Space.margin10),
        
                    quantityPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.margin8),
                    quantityPanel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Space.margin8),
        
                    orderbookPanel.topAnchor.constraint(equalTo: symbolInfoView.bottomAnchor, constant: Space.margin8),
                    orderbookPanel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Space.margin8),
                    orderbookPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.margin8),
        
                    tradeHistoryContainer.topAnchor.constraint(equalTo: orderbookPanel.bottomAnchor, constant: Space.margin16),
                    tradeHistoryContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.margin8),
                    tradeHistoryContainer.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Space.margin8),
                    tradeHistoryContainer.bottomAnchor.constraint(equalTo: tradeView.topAnchor, constant: -Space.margin10),
        
                    tradeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    tradeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    tradeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Space.margin16)
                ])
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .blue
        let label = UILabel()
        label.text = "What Up"
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(tradeHistoryTable.view)
        NSLayoutConstraint.activate([
            tradeHistoryTable.view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            tradeHistoryTable.view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            tradeHistoryTable.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            tradeHistoryTable.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        return cell
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
        if size > Int(maxBybitContracts) { size = Int(maxBybitContracts) }
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
        guard
            let quantity = quantityLabel.text,
            let price = priceLabel.text,
            let leverage = currentLeverageLabel.text
            else { return }
        hapticFeedback()
        let vc = BybitQuantityUpdateViewController(quantity: quantity, price: price, leverage: String(leverage.dropLast()), observer: self)
        present(vc, animated: true)
    }
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
