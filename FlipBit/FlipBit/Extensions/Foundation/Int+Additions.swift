//
//  Int+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/27/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension Int {
    func formatBybitPriceString() -> String? {
        guard
            let books = bookObserver.buyBook,
            let book = books.first,
            let price = book?.price
            else { return nil }
        let priceString = String(self)
        let priceCount = price.count - 1
        let startIndex = priceString.index(priceString.startIndex, offsetBy: 0)
        let endIndex = priceString.index(priceString.startIndex, offsetBy: priceCount)
        var result = String(priceString[startIndex..<endIndex])
        result.insert(".", at: result.index(result.endIndex, offsetBy: -2))
        return result
    }
}
