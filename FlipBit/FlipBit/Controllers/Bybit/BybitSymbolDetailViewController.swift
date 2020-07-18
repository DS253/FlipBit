//
//  BybitSymbolDetailViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 7/18/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import Starscream
import UIKit

class BybitSymbolDetailViewController: FlipBitCollectionViewController, SocketObserverDelegate {
    
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
    
    enum Section: Int, CaseIterable {
        case chart
        case infoTitle
        case info
        case orderBookTitle
        case orderBook
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //collectionView.reloadData()
        print("CONTENT SIZE: \(collectionView.contentSize)")
    }
    
    override func setup() {
        super.setup()
        bookObserver.delegate = self
        symbolObserver.delegate = self
        tradeObserver.delegate = self
        view.backgroundColor = themeManager.themeBackgroundColor
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.id)
        collectionView.register(PriceCollectionViewCell.self, forCellWithReuseIdentifier: PriceCollectionViewCell.id)
        collectionView.register(ChartCollectionViewCell.self, forCellWithReuseIdentifier: ChartCollectionViewCell.id)
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.id)
        collectionView.register(OrderBookCollectionViewCell.self, forCellWithReuseIdentifier: OrderBookCollectionViewCell.id)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        //        view.addSubview(symbolInfoView)
        //        view.addSubview(leverageContainer)
        //        view.addSubview(orderbookPanel)
        //        view.addSubview(pricePanel)
        //        view.addSubview(quantityPanel)
        //        view.addSubview(tradeHistoryContainer)
        //        view.addSubview(tradeView)
        
        tradeView.configureButtons(self, action: #selector(tradeButtonTapped(sender:)))
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        //        symbolInfoView.snp.makeConstraints { make in
        //            make.top.leading.trailing.equalToSuperview()
        //        }
        
        //        NSLayoutConstraint.activate([
        //
        //            leverageContainer.topAnchor.constraint(equalTo: orderbookPanel.topAnchor),
        //            leverageContainer.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Space.margin8),
        //            leverageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.margin8),
        //            leverageContainer.bottomAnchor.constraint(equalTo: pricePanel.topAnchor, constant: -Space.margin10),
        //
        //            pricePanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.margin8),
        //            pricePanel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Space.margin8),
        //            pricePanel.bottomAnchor.constraint(equalTo: quantityPanel.topAnchor, constant: -Space.margin10),
        //
        //            quantityPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.margin8),
        //            quantityPanel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Space.margin8),
        //
        //            orderbookPanel.topAnchor.constraint(equalTo: symbolInfoView.bottomAnchor, constant: Space.margin8),
        //            orderbookPanel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Space.margin8),
        //            orderbookPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.margin8),
        //            orderbookPanel.heightAnchor.constraint(equalToConstant: 500.0),
        //
        //            tradeHistoryContainer.topAnchor.constraint(equalTo: orderbookPanel.bottomAnchor, constant: Space.margin16),
        //            tradeHistoryContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.margin8),
        //            tradeHistoryContainer.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Space.margin8),
        //            tradeHistoryContainer.bottomAnchor.constraint(equalTo: tradeView.topAnchor, constant: -Space.margin10),
        //
        //            tradeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        //            tradeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        //            tradeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Space.margin16)
        //        ])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionViewSection = Section(rawValue: section) else { return 0 }
        
        switch collectionViewSection {
        case .chart, .infoTitle, .info, .orderBookTitle, .orderBook:
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> BaseCollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return BaseCollectionViewCell(frame: .zero) }
        switch section {
        case .chart:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.id, for: indexPath) as? ChartCollectionViewCell
                else { return ChartCollectionViewCell(frame: .zero) }
            
            return cell
            
        case .infoTitle:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as? TitleCollectionViewCell
                else {
                    return TitleCollectionViewCell(frame: .zero)
            }
            cell.configure(title: "Stats")
            return cell
            
        case .info:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.id, for: indexPath) as? InfoCollectionViewCell
                else {
                    return InfoCollectionViewCell(frame: .zero)
            }
            
            return cell
            
        case .orderBookTitle:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as? TitleCollectionViewCell
                else {
                    return TitleCollectionViewCell(frame: .zero)
            }
            cell.configure(title: "Orderbook")
            return cell
            
        case .orderBook:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderBookCollectionViewCell.id, for: indexPath) as? OrderBookCollectionViewCell
                else {
                    return OrderBookCollectionViewCell(frame: .zero)
            }
            
            return cell
        }
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
        //        let vc = BybitTradeFlowViewController(order: order)
        //        present(vc, animated: true)
    }
    
    @objc func updateSymbolInfo(notification: NSNotification) {
        guard
            let newInfo = symbolObserver.symbolInfo,
            let price = newInfo.lastPrice
            else { return }
        priceLabel.text = price.formatPriceString(notation: 4)
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

extension BybitSymbolDetailViewController: PriceSelection {
    func priceSelected(price: String) {
        priceLabel.text = price
    }
}

extension BybitSymbolDetailViewController: QuantitySelection {
    func quantitySelected(quantity: String) {
        quantityLabel.text = quantity
    }
}

extension BybitSymbolDetailViewController: LeverageObserver {
    func leverageUpdated(leverage: String) {
        self.currentLeverageLabel.text = "\(leverage)x"
    }
}

extension BybitSymbolDetailViewController: PriceObserver {
    func priceUpdated(price: String) {
        self.priceLabel.text = price
    }
}

extension BybitSymbolDetailViewController: QuantityObserver {
    func quantityUpdated(quantity: String) {
        self.quantityLabel.text = quantity
    }
}

