//
//  FlipBitTextField.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/22/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class FlipBitTextField: UITextField {

    private let padding = UIEdgeInsets(top: 12.0, left: 9.0, bottom: 10.0, right: 8.0)
    
    init(keyboardType: UIKeyboardType = .default, textColor: UIColor, font: UIFont, textAlignment: NSTextAlignment = .left) {
        super.init(frame: .zero)
        self.keyboardType = keyboardType
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        clearButtonMode = UITextField.ViewMode.never
        autocorrectionType = .no
        spellCheckingType = .no
        inputAssistantItem.leadingBarButtonGroups = []
        inputAssistantItem.trailingBarButtonGroups = []
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.rightViewRect(forBounds: bounds)
        newBounds.origin.x -= Dimensions.Space.margin20
        return newBounds
    }
}
