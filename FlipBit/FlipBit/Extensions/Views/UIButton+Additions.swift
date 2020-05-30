//
//  UIButton+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/7/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

extension UIButton {
    
    /// Th@objc is is a helper method to inline assignment of the `type`, `title` and `textColor` to cut down
    /// on extraneous, and repeated, lines of code.
    ///
    /// - Note: This method also assigns the `translatesAutoresizingMaskIntoConstraints` to
    ///         `false` to eliminate the need to repeated assign this value.
    convenience init(type: UIButton.ButtonType = .custom, title: String, textColor: UIColor = .black, font: UIFont = UIFont.callout, enabled: Bool = true, selected: Bool = false) {
        self.init(type: type)
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .highlighted)
        self.setTitle(title, for: .selected)
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font = font
        self.isEnabled = enabled
        self.isSelected = selected
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}
