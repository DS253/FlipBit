//
//  OrderBookBaseView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/29/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class OrderBookBaseView: View {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var firstRow: OrderBookRow = {
        OrderBookRow(font: UIFont.footnote, colorTheme: colorTheme())
    }()
    
    lazy var secondRow: OrderBookRow = {
        OrderBookRow(font: UIFont.footnote.bold, colorTheme: colorTheme())
    }()
    
    lazy var thirdRow: OrderBookRow = {
        OrderBookRow(font: UIFont.footnote.bold, colorTheme: colorTheme())
    }()
    
    lazy var fourthRow: OrderBookRow = {
        OrderBookRow(font: UIFont.subheadline, colorTheme: colorTheme())
    }()
    
    lazy var fifthRow: OrderBookRow = {
        OrderBookRow(font: UIFont.subheadline.semibold, colorTheme: colorTheme())
    }()
    
    lazy var sixthRow: OrderBookRow = {
        OrderBookRow(font: UIFont.subheadline.bold, colorTheme: colorTheme())
    }()
        
    deinit {
        NotificationCenter.default.removeObserver(self, name: notificationName(), object: nil)
    }
    
    override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(updateBookRows(notification:)), name: notificationName(), object: nil)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        addSubview(stackView)
        stackView.addArrangedSubview(firstRow)
        stackView.addArrangedSubview(secondRow)
        stackView.addArrangedSubview(thirdRow)
        stackView.addArrangedSubview(fourthRow)
        stackView.addArrangedSubview(fifthRow)
        stackView.addArrangedSubview(sixthRow)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func setPriceSelector(selector: PriceSelection) {
        firstRow.priceSelector = selector
        secondRow.priceSelector = selector
        thirdRow.priceSelector = selector
        fourthRow.priceSelector = selector
        fifthRow.priceSelector = selector
        sixthRow.priceSelector = selector
    }

    func setQuantitySelector(selector: QuantitySelection) {
        firstRow.quantitySelector = selector
        secondRow.quantitySelector = selector
        thirdRow.quantitySelector = selector
        fourthRow.quantitySelector = selector
        fifthRow.quantitySelector = selector
        sixthRow.quantitySelector = selector
    }

    func notificationName() -> Notification.Name {
        fatalError("Must be implemented by child class")
    }
    
    func colorTheme() -> UIColor {
        fatalError("Must be implemented by child class")
    }

    @objc func updateBookRows(notification: Notification) {
        fatalError("Must be implemented by child class")
    }
}
