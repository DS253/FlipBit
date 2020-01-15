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
    
    func orderBook() -> [Bybit.BookOrder?]? {
        fatalError("Must be implemented by child class")
    }
    
    func allRows() -> [OrderBookRow] {
        fatalError("Must be implemented by child class")
    }

    func notificationName() -> Notification.Name {
        fatalError("Must be implemented by child class")
    }
    
    func colorTheme() -> UIColor {
        fatalError("Must be implemented by child class")
    }
    
    @objc func updateBookRows(notification: Notification) {
        guard let book = orderBook() else { return }
        let rows = allRows()
        if book.count >= 1 {
            guard let firstOrder = book[0] else { return }
            rows[0].configure(with: firstOrder, multiplier: bookObserver.percentageOf(book, size: firstOrder.size ?? 0))
        }
        if book.count >= 2 {
            guard let secondOrder = book[1] else { return }
            rows[1].configure(with: secondOrder, multiplier: bookObserver.percentageOf(book, size: secondOrder.size ?? 0))
        }
        
        if book.count >= 3 {
            guard let thirdOrder = book[2] else { return }
            rows[2].configure(with: thirdOrder, multiplier: bookObserver.percentageOf(book, size: thirdOrder.size ?? 0))
        }
        
        if book.count >= 4 {
            guard let fourthOrder = book[3] else { return }
            rows[3].configure(with: fourthOrder, multiplier: bookObserver.percentageOf(book, size: fourthOrder.size ?? 0))
        }
        if book.count >= 5 {
            guard let fifthOrder = book[4] else { return }
            rows[4].configure(with: fifthOrder, multiplier: bookObserver.percentageOf(book, size: fifthOrder.size ?? 0))
        }
        
        if book.count >= 6 {
            guard let sixthOrder = book[5] else { return }
            rows[5].configure(with: sixthOrder, multiplier: bookObserver.percentageOf(book, size: sixthOrder.size ?? 0))
        }
    }
}
