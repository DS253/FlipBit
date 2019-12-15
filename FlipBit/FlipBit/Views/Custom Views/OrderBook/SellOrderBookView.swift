//
//  SellOrderBookView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/29/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class SellOrderBookView: OrderBookBaseView {
    
    override func orderBook() -> [Bybit.BookOrder?]? {
        return bookObserver.sellBook
    }
    
    override func allRows() -> [OrderBookRow] {
        return [firstRow, secondRow, thirdRow, fourthRow, fifthRow,  sixthRow]
    }
    
    override func notificationName() -> Notification.Name {
        return .sellBookObserverUpdate
    }
    
    override func colorTheme() -> UIColor {
        return UIColor.flatWatermelonDark
    }
    
    func configureViewForSellBook() {
        firstRow.priceLabel.font = UIFont.subheadline.bold
        firstRow.quantityLabel.font = UIFont.subheadline.bold
        secondRow.priceLabel.font = UIFont.subheadline.semibold
        secondRow.quantityLabel.font = UIFont.subheadline.semibold
        thirdRow.priceLabel.font = UIFont.subheadline
        thirdRow.quantityLabel.font = UIFont.subheadline
        fourthRow.priceLabel.font = UIFont.footnote.bold
        fourthRow.quantityLabel.font = UIFont.footnote.bold
        fifthRow.priceLabel.font = UIFont.footnote.semibold
        fifthRow.quantityLabel.font = UIFont.footnote.semibold
        sixthRow.priceLabel.font = UIFont.footnote
        sixthRow.quantityLabel.font = UIFont.footnote
    }
}
