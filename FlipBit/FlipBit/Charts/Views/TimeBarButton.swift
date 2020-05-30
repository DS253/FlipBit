//
//  TimeBarButton.swift
//  FlipBit
//
//  Created by Daniel Stewart on 5/30/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

/// The button below the `ChartView` that controls the time segment displayed.
class TimeBarButton: UIButton {
    
    init(type: UIButton.ButtonType = .custom, title: String, textColor: UIColor = .black, font: UIFont = UIFont.callout, selected: Bool = false) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .highlighted)
        self.setTitle(title, for: .selected)
        self.setTitleColor(textColor, for: .normal)
        self.setTitleColor(themeManager.darkModeTheme, for: .selected)
        self.titleLabel?.font = font
        self.isSelected = selected
        self.clipsToBounds = true
        self.setBackgroundColor(color: themeManager.darkModeTheme, forState: .normal)
        self.setBackgroundColor(color: themeManager.buyTextColor, forState: .selected)
        self.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
