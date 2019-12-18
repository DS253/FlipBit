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

    private lazy var fullscreenActivityIndicator = ActivityIndicatorViewController()

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
        label.text = " "
        return label
    }()

    private lazy var percentageContainer: PercentageView = {
        let percentageView = PercentageView()
        percentageView.configureButtonActions(viewController: self, action: #selector(addByPercentage(sender:)), event: .touchUpInside)
        return percentageView
    }()

    private lazy var buyButton: UIButton = {
        let button = UIButton(type: .custom, title: Constant.buy, textColor: UIColor.flatMint)
        button.titleLabel?.font = UIFont.title3.bold
        button.layer.borderWidth = 4.0
        button.layer.borderColor = UIColor.flatMint.cgColor
        button.layer.cornerRadius = 7.0
        return button
    }()

    private lazy var sellButton: UIButton = {
        let button = UIButton(type: .custom, title: Constant.sell, textColor: UIColor.flatWatermelon)
        button.titleLabel?.font = UIFont.title3.bold
        button.layer.borderWidth = 4.0
        button.layer.borderColor = UIColor.flatWatermelon.cgColor
        button.layer.cornerRadius = 7.0
        return button
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

    private lazy var pricePickerView: ValuePickerView = {
        ValuePickerView(title: Constant.orderPrice, value: "7100")
    }()

    private lazy var quantityPickerView: ValuePickerView = {
        ValuePickerView(title: Constant.orderQuantity, value: "10000")
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
        optionsViewGradient.frame = CGRect(x: .zero, y: .zero, width: tradeView.bounds.size.width, height: optionsViewGradientHeight)
    }

    override func setup() {
        super.setup()
        bookObserver.delegate = self
        symbolObserver.delegate = self
        tradeObserver.delegate = self
//        positionObserver.delegate = self
        orderbookPanel.setPriceSelector(selector: pricePickerView)
        orderbookPanel.setQuantitySelector(selector: quantityPickerView)
        view.backgroundColor = UIColor.Bybit.white
        tradeView.configureButtons(self, buyAction: #selector(buyButtonTapped(sender:)), sellAction: #selector(sellButtonTapped(sender:)))
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
        view.addSubview(tradeView)
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

            pricePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin8),
            pricePickerView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Dimensions.Space.margin8),
            pricePickerView.bottomAnchor.constraint(equalTo: quantityPickerView.topAnchor, constant: -Dimensions.Space.margin8),

            quantityPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin8),
            quantityPickerView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Dimensions.Space.margin8),
            quantityPickerView.bottomAnchor.constraint(equalTo: percentageContainer.topAnchor, constant: -Dimensions.Space.margin16),

            orderbookPanel.topAnchor.constraint(equalTo: symbolInfoView.bottomAnchor, constant: Dimensions.Space.margin8),
            orderbookPanel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Dimensions.Space.margin8),
            orderbookPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimensions.Space.margin8),

            percentageContainer.bottomAnchor.constraint(equalTo: orderbookPanel.bottomAnchor),
            percentageContainer.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: Dimensions.Space.margin8),
            percentageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Dimensions.Space.margin8),

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

    @objc func addByPercentage(sender: UIButton) {
        print(sender.titleLabel?.text as Any)
    }

    @objc func buyButtonTapped(sender: UIButton) {
        print("Buy Button Tapped")

        present(fullscreenActivityIndicator, animated: true)

//        let tradeFlow = BybitTradeFlowViewController()
//        tradeFlow.modalPresentationStyle = .popover
//        tradeFlow.modalTransitionStyle = .crossDissolve
//        present(tradeFlow, animated: true)
    }

    @objc func sellButtonTapped(sender: UIButton) {
        print("Sell Button Tapped")

        fullscreenActivityIndicator.dismiss(animated: true)
    }
}
