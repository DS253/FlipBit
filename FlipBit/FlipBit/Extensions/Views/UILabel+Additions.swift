//
//  UILabel+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/20/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

extension UILabel {

    /// This is a helper method to inline assignment of the `textColor` and `font` to cut down
    /// on extraneous, and repeated, lines of code.
    ///
    /// - Note: This method also assigns the `translatesAutoresizingMaskIntoConstraints` to
    ///         `false` to eliminate the need to repeated assign this value.
    convenience init(font: UIFont, textColor: UIColor = .black) {
        self.init()

        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = textColor
        self.font = font
    }
}
