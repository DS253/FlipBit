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
        UIStackView(spacing: Space.margin2, views: [firstRow, secondRow, thirdRow, fourthRow, fifthRow, sixthRow, seventhRow])
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
    
    lazy var seventhRow: OrderBookRow = {
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
        backgroundColor = themeManager.themeBackgroundColor
        
        addSubview(stackView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
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
        
        if book.count >= 7 {
            guard let seventhOrder = book[6] else { return }
            rows[6].configure(with: seventhOrder, multiplier: bookObserver.percentageOf(book, size: seventhOrder.size ?? 0))
        }
    }
}
