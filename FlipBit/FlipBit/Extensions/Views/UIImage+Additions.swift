//
//  UIImage+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/27/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

extension UIImage {
    
    enum Name: String {
        case TickerArrow = "tickerArrow"
    }
    
    convenience init?(name: Name) {
        self.init(named: name.rawValue)
    }
}
