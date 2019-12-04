//
//  Constants.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

let theAPIKey = "tjLNabTKzKmtlvE6Qs"
let secret = "JiT2BnTVwhTjifzfWqPkQV8Q0Mbprnbr7ZRW"
//let theAPIKey = "Mqvkxv3jRP9H2ExK3h"
//let secret = "4VDDtErgd0uLYDBwI63S27pFcHRNvBKtS9C5"

typealias View = BaseView
typealias ViewController = BaseViewController

struct Constant {
    
    // MARK: - Common
    static let buy = "Buy"
    static let long = "Long"
    static let orderPrice = "Order Price USD"
    static let orderQuantity = "Order Quantity USD"
    static let price = "Price"
    static let quantity = "Quantity"
    static let sell = "Sell"
    static let short = "Short"
    
    // MARK: - Symbol Info
    static let dayHighTitle = "24h High"
    static let dayLowTitle = "24h Low"
    static let dayTurnoverTitle = "24h Turnover"

    // MARK: - Miscellaneous

    static let tableViewReloadDataAnimationKey = "UITableViewReloadDataAnimationKey"
}
