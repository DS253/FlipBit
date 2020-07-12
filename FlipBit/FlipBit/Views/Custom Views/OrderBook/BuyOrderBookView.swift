//
//  BuyOrderBookView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/29/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BuyOrderBookView: View {
    
    private lazy var stackView: UIStackView = {
        UIStackView(spacing: Space.margin2, views: [firstRow, secondRow, thirdRow, fourthRow, fifthRow, sixthRow, seventhRow, eighthRow, ninthRow, tenthRow])
    }()
    
    lazy var firstRow: BuyBookRow = {
        BuyBookRow(font: UIFont.subheadline)
    }()
    
    lazy var secondRow: BuyBookRow = {
        BuyBookRow(font: UIFont.subheadline)
    }()
    
    lazy var thirdRow: BuyBookRow = {
        BuyBookRow(font: UIFont.subheadline)
    }()
    
    lazy var fourthRow: BuyBookRow = {
        BuyBookRow(font: UIFont.subheadline)
    }()
    
    lazy var fifthRow: BuyBookRow = {
        BuyBookRow(font: UIFont.subheadline)
    }()
    
    lazy var sixthRow: BuyBookRow = {
        BuyBookRow(font: UIFont.subheadline)
    }()
    
    lazy var seventhRow: BuyBookRow = {
        BuyBookRow(font: UIFont.subheadline)
    }()
    
    lazy var eighthRow: BuyBookRow = {
        BuyBookRow(font: UIFont.subheadline)
    }()
    
    lazy var ninthRow: BuyBookRow = {
        BuyBookRow(font: UIFont.subheadline)
    }()
    
    lazy var tenthRow: BuyBookRow = {
        BuyBookRow(font: UIFont.subheadline)
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .buyBookObserverUpdate, object: nil)
    }
    
    override func setup() {
        super.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(updateBookRows(notification:)), name: .buyBookObserverUpdate, object: nil)
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
    
    func notificationName() -> Notification.Name {
        fatalError("Must be implemented by child class")
    }
    
    @objc func updateBookRows(notification: Notification) {
        guard let book = bookObserver.buyBook else { return }
        if book.count >= 1 {
            guard let firstOrder = book[0] else { return }
            firstRow.configure(with: firstOrder, multiplier: bookObserver.percentageOf(book, size: firstOrder.size ?? 0))
        }
        if book.count >= 2 {
            guard let secondOrder = book[1] else { return }
            secondRow.configure(with: secondOrder, multiplier: bookObserver.percentageOf(book, size: secondOrder.size ?? 0))
        }
        
        if book.count >= 3 {
            guard let thirdOrder = book[2] else { return }
            thirdRow.configure(with: thirdOrder, multiplier: bookObserver.percentageOf(book, size: thirdOrder.size ?? 0))
        }
        
        if book.count >= 4 {
            guard let fourthOrder = book[3] else { return }
            fourthRow.configure(with: fourthOrder, multiplier: bookObserver.percentageOf(book, size: fourthOrder.size ?? 0))
        }
        if book.count >= 5 {
            guard let fifthOrder = book[4] else { return }
            fifthRow.configure(with: fifthOrder, multiplier: bookObserver.percentageOf(book, size: fifthOrder.size ?? 0))
        }
        
        if book.count >= 6 {
            guard let sixthOrder = book[5] else { return }
            sixthRow.configure(with: sixthOrder, multiplier: bookObserver.percentageOf(book, size: sixthOrder.size ?? 0))
        }
        
        if book.count >= 7 {
            guard let seventhOrder = book[6] else { return }
            seventhRow.configure(with: seventhOrder, multiplier: bookObserver.percentageOf(book, size: seventhOrder.size ?? 0))
        }
        
        if book.count >= 8 {
            guard let eighthOrder = book[7] else { return }
            eighthRow.configure(with: eighthOrder, multiplier: bookObserver.percentageOf(book, size: eighthOrder.size ?? 0))
        }
        
        if book.count >= 9 {
            guard let ninthOrder = book[8] else { return }
            ninthRow.configure(with: ninthOrder, multiplier: bookObserver.percentageOf(book, size: ninthOrder.size ?? 0))
        }
        
        if book.count >= 10 {
            guard let tenthOrder = book[9] else { return }
            tenthRow.configure(with: tenthOrder, multiplier: bookObserver.percentageOf(book, size: tenthOrder.size ?? 0))
        }
    }
}
