//
//  BuyOrderBookView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/29/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BuyOrderBookView: OrderBookBaseView {
    
    override func notificationName() -> Notification.Name {
        return .buyBookObserverUpdate
    }
    
    override func colorTheme() -> UIColor {
        return UIColor.Bybit.orderbookGreen
    }
    
    @objc override func updateBookRows(notification: Notification) {
        guard
            let book = bookObserver.buyBook,
            let firstOrder = book[0],
            let secondOrder = book[1],
            let thirdOrder = book[2],
            let fourthOrder = book[3],
            let fifthOrder = book[4]
            else { return }
        firstRow.configure(with: fifthOrder, multiplier: bookObserver.returnPercentageOfBuyOrder(size: firstOrder.size ?? 0))
        secondRow.configure(with: fourthOrder, multiplier: bookObserver.returnPercentageOfBuyOrder(size: secondOrder.size ?? 0))
        thirdRow.configure(with: thirdOrder, multiplier: bookObserver.returnPercentageOfBuyOrder(size: thirdOrder.size ?? 0))
        fourthRow.configure(with: secondOrder, multiplier: bookObserver.returnPercentageOfBuyOrder(size: fourthOrder.size ?? 0))
        fifthRow.configure(with: firstOrder, multiplier: bookObserver.returnPercentageOfBuyOrder(size: fifthOrder.size ?? 0))
    }
}