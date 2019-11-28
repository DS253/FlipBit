//
//  Int+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/27/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension Int {
    
    func formatPriceString(notation: Int) -> String? {
        let value = pow(10, notation) as NSNumber
        let processedNumber = Double(self)/value.doubleValue
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .up
        
        guard let string = formatter.string(from: NSNumber(value: processedNumber)) else { return nil }
        return string.replacingOccurrences(of: ",", with: "")
    }
    
    func formatWithKNotation(notation: Int) -> String? {
        let value = pow(10, notation) as NSNumber
        let processedNumber = Double(self)/value.doubleValue / 1000
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .up
        
        guard var string = formatter.string(from: NSNumber(value: processedNumber)) else { return nil }
        string.append("K")
        return string.replacingOccurrences(of: ",", with: "")
    }
}
