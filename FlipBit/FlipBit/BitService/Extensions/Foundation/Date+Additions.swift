//
//  Date+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

internal extension Date {
    
    /// Provides specified date time formats
    enum Format: String {
        case bybitDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case chartFormat = "H:mm a, MMM d"
        case shortHand = "yyyy-MM-dd"
    }
    
        /// Provides a default date formatter for use with dates from services
    static var formatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.Format.bybitDateFormat.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }

    static var utcCalendar: Calendar {
        var calendar = Calendar.current
        guard let gmtTimeZone = TimeZone(secondsFromGMT: 0) else { fatalError("Could not initialize the GMT time zone.") }
        calendar.timeZone = gmtTimeZone
        return calendar
    }

    /// Evaluates current date to determine if its in the future.
    var isFuture: Bool {
        return Date() < self
    }

    /// Evaluates current date to determine if its in the past.
    var isPast: Bool {
        return Date() > self
    }

    /// Returns a date to the nearest day.
    var day: Date? {
        let newComponents = Date.utcCalendar.dateComponents([.year, .month, .day], from: self)
        return Date.utcCalendar.date(from: newComponents)
    }

    /// Returns a date to the nearest minute.
    var minute: Date? {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return Calendar.current.date(from: dateComponents)
    }
    
    /// Returns a date to the nearest second.
    var second: Date? {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return Calendar.current.date(from: dateComponents)
    }

    /// Inits from a string using our global date formatter.
    init?(from string: String, format: Date.Format = .bybitDateFormat) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let date = dateFormatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }

    /// Returns a string of the date in the specified format
    func string(_ format: Format) -> String {
        let formatter = Date.formatter
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
    /// Returns a string of the expected timestamp in seconds
    func bybitSocketTimestamp() -> String {
        let seconds = (NSDate().timeIntervalSince1970 * 1000) + 1000
        let secondsConverted = String(seconds).components(separatedBy: ".")
        return secondsConverted[0]
    }

    func bybitTimestamp() -> String {
        let seconds = (NSDate().timeIntervalSince1970 * 1000) - 16000
        let secondsConverted = String(seconds).components(separatedBy: ".")
        return secondsConverted[0]
    }
}
