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
    convenience init(text: String = "", font: UIFont?, textColor: UIColor = .black, textAlignment: NSTextAlignment = .left) {
        self.init()
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = textColor
        if let newFont = font { self.font = newFont }
        self.textAlignment = textAlignment
    }
    
    // Adds a `UIGestureRecognizer` and enables user interaction.
    override open func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        super.addGestureRecognizer(gestureRecognizer)
        isUserInteractionEnabled = true
    }
}

extension UILabel {
  
  func configureTitleLabel(withText text: String) {
    configure(withText: text.uppercased(), size: .titleTextSize, alignment: .left, lines: 0)
  }
  
  func configureTextLabel(withText text: String) {
    configure(withText: text, size: .textTextSize, alignment: .left, lines: 0)
  }
  
  func configureLinkLabel(withText text: String) {
    configure(withText: text.uppercased(), size: .linkTextSize, alignment: .left, lines: 0)
  }
  
  private func configure(withText newText: String,
                         size: CGFloat,
                         alignment: NSTextAlignment,
                         lines: Int) {
    text = newText
    font = .boldSystemFont(ofSize: 34.0)
    textAlignment = alignment
    numberOfLines = lines
    lineBreakMode = .byTruncatingTail
  }
}
