//
//  Date+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

internal extension Date {
    /// Returns date as a string in standard format.
    var standardString: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")

        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(from: self)
    }
    
    /// Returns a string of the expected timestamp in seconds
    func bybitTimestamp() -> String {
        let secondsConverted = String(NSDate().timeIntervalSince1970 * 1000).components(separatedBy: ".")
        return secondsConverted[0]
    }
}
