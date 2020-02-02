//
//  ThemeManager.swift
//  FlipBit
//
//  Created by Daniel Stewart on 2/1/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

/// Provides all expected color themes of FlipBit.
class ThemeManager {
    
    var themeBackgroundColor: UIColor = #colorLiteral(red: 0, green: 0.02311643836, blue: 0, alpha: 1)
    var themeFontColor: UIColor = #colorLiteral(red: 0.9334599743, green: 1, blue: 0.9361622432, alpha: 1)
    
    var lightModeTheme: UIColor = #colorLiteral(red: 0.9334599743, green: 1, blue: 0.9361622432, alpha: 1)
    var darkModeTheme: UIColor = #colorLiteral(red: 0, green: 0.02311643836, blue: 0, alpha: 1)
    
    var presentationBackgroundColor: UIColor = .black
    
    /// Font Colors
    var buyTextColor = UIColor.flatMintDark
    var sellTextColor = UIColor.flatWatermelonDark
    var disabledTextColor = UIColor.flatGray
    
    /// Common Colors
    var blackColor: UIColor = .black
    var clearColor: UIColor = .clear
    var whiteColor: UIColor = .white
}
