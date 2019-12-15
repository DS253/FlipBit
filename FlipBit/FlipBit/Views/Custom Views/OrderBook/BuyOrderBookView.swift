//
//  BuyOrderBookView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/29/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class BuyOrderBookView: OrderBookBaseView {
    
    override func orderBook() -> [Bybit.BookOrder?]? {
        return bookObserver.buyBook
    }
    
    override func allRows() -> [OrderBookRow] {
        return [sixthRow, fifthRow, fourthRow, thirdRow, secondRow, firstRow]
    }
    
    override func notificationName() -> Notification.Name {
        return .buyBookObserverUpdate
    }
    
    override func colorTheme() -> UIColor {
        return UIColor.flatMintDark
    }
}
