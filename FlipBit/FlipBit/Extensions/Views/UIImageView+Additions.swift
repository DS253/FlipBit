//
//  UIImageView+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/27/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

extension UIImageView {
    convenience init(name: UIImage.Name, tintColor: UIColor) {
        self.init(image: UIImage(name: name)?.withRenderingMode(.alwaysTemplate))
        self.tintColor = tintColor
    }
}
