//
//  SellOrderBookView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/29/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class SellOrderBookView: OrderBookBaseView {
    
    override func notificationName() -> Notification.Name {
        return .sellBookObserverUpdate
    }
    
    override func colorTheme() -> UIColor {
        return UIColor.Bybit.orderbookRed
    }
    
    @objc override func updateBookRows(notification: Notification) {
        guard
            let book = bookObserver.sellBook,
            let firstOrder = book[0],
            let secondOrder = book[1],
            let thirdOrder = book[2],
            let fourthOrder = book[3],
            let fifthOrder = book[4],
        let sixthOrder = book[5]
            else { return }
        firstRow.configure(with: firstOrder, multiplier: bookObserver.returnPercentageOfSellOrder(size: firstOrder.size ?? 0))
        secondRow.configure(with: secondOrder, multiplier: bookObserver.returnPercentageOfSellOrder(size: secondOrder.size ?? 0))
        thirdRow.configure(with: thirdOrder, multiplier: bookObserver.returnPercentageOfSellOrder(size: thirdOrder.size ?? 0))
        fourthRow.configure(with: fourthOrder, multiplier: bookObserver.returnPercentageOfSellOrder(size: fourthOrder.size ?? 0))
        fifthRow.configure(with: fifthOrder, multiplier: bookObserver.returnPercentageOfSellOrder(size: fifthOrder.size ?? 0))
        sixthRow.configure(with: sixthOrder, multiplier: bookObserver.returnPercentageOfSellOrder(size: sixthOrder.size ?? 0))
    }
    
    func configureViewForSellBook() {
        firstRow.priceLabel.font = UIFont.subheadline.bold
        firstRow.quantityLabel.font = UIFont.subheadline.bold
        secondRow.priceLabel.font = UIFont.subheadline
        secondRow.quantityLabel.font = UIFont.subheadline
        fourthRow.priceLabel.font = UIFont.footnote
        fourthRow.quantityLabel.font = UIFont.footnote
        
        fifthRow.priceLabel.font = UIFont.caption.bold
        fifthRow.quantityLabel.font = UIFont.caption.bold
        sixthRow.priceLabel.font = UIFont.caption.bold
        sixthRow.quantityLabel.font = UIFont.caption.bold
        
    }
}
