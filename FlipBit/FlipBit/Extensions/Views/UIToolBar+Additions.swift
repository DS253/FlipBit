//
//  UIToolBar+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 1/20/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

extension UIToolbar {
    
    convenience init(frame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100), barItems: [UIBarButtonItem]) {
        self.init(frame: frame)
        self.barStyle = .default
        self.setItems(barItems, animated: false)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
