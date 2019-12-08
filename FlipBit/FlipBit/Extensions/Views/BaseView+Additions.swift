//
//  BaseView+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/30/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

extension BaseView {
    
    func setBybitTheme() {
        layer.cornerRadius = 14
        layer.borderColor = UIColor.flatNavyBlue.cgColor
        layer.borderWidth = 1.0
        layer.shadowColor = UIColor.flatNavyBlue.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: -1, height: 6)
        layer.masksToBounds = false
    }
}
