//
//  UIButton+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/7/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

extension UIButton {
    
    /// This is a helper method to inline assignment of the `type`, `title` and `textColor` to cut down
    /// on extraneous, and repeated, lines of code.
    ///
    /// - Note: This method also assigns the `translatesAutoresizingMaskIntoConstraints` to
    ///         `false` to eliminate the need to repeated assign this value.
    convenience init(type: UIButton.ButtonType = .custom, title: String, textColor: UIColor = .black) {
        self.init(type: type)
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
    }
}
