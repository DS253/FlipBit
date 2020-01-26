//
//  Space.swift
//  FlipBit
//
//  Created by Daniel Stewart on 1/25/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

struct Space {
    
    struct WidthMultiplier { }
    
    /// A 1-pixel dimension that can be used for thinnest-possible lines, based on screen scale.
    internal static let singlePixel: CGFloat = 1.0 / UIScreen.main.scale
    
    static let margin1: CGFloat = 1.0
    
    /// Space between labels contained in a table cell
    static let margin2: CGFloat = 2.0
    
    /// Default space between labels top space (top / bottom).
    static let margin4: CGFloat = 4.0
    
    /// Default space as per Apple HIG.
    static let margin8: CGFloat = 8.0
    
    static let margin10: CGFloat = 10.0
    
    /// Default space between UI elements.
    static let margin12: CGFloat = 12.0
    
    /// Default space between UI elements.
    static let margin14: CGFloat = 14.0
    
    /// Default, exaggerated space between titles and the rest of UI elements.
    static let margin16: CGFloat = 16.0
    
    static let margin18: CGFloat = 18.0
    
    /// Default space between nested subviews.
    static let margin20: CGFloat = 20.0
    
    static let margin22: CGFloat = 22.0
    
    static let margin24: CGFloat = 24.0
    
    /// Default space between major UI elements.
    static let margin26: CGFloat = 26.0
    
    /// Default space between major UI elements.
    static let margin28: CGFloat = 28.0
    
    static let margin32: CGFloat = 32.0
    
    static let margin40: CGFloat = 40.0
    
    static let margin42: CGFloat = 42.0
    
    static let margin48: CGFloat = 48.0
    
    /// Default height of table header
    static let margin50: CGFloat = 50.0
    
    static let margin96: CGFloat = 96.0
}


/// Defines the multipliers for a twelve-column grid layout, with 16pts of padding between each column.
extension Space.WidthMultiplier {
    
    static let oneColumn: CGFloat = 0.061
    
    static let twoColumns: CGFloat = 0.142
    
    static let threeColumns: CGFloat = 0.224
    
    static let fourColumns: CGFloat = 0.306
    
    static let fiveColumns: CGFloat = 0.387
    
    static let sixColumns: CGFloat = 0.469
    
    static let sevenColumns: CGFloat = 0.551
    
    static let eightColumns: CGFloat = 0.632
    
    static let nineColumns: CGFloat = 0.714
    
    static let tenColumns: CGFloat = 0.796
    
    static let elevenColumns: CGFloat = 0.876
    
    static let twelveColumns: CGFloat = 0.958
}
