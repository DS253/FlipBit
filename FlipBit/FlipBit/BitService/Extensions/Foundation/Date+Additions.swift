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
        /// Represents "MMM dd, yyyy"
        case shortMonthDayYear = "MMM dd, yyyy"
        /// Represents "yyyy-MM-dd'T'HH:mm:ss"
        case bybitDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        /// Represents "d MMM yyyy"
        case dayShortMonthYear = "d MMM yyyy"
        /// Represents "dd-MM-yyyy"
        case dayMonthYear = "dd-MM-yyyy"
        /// Represents "dd MMM yyyy"
        case dayMonthNameYear = "dd MMM yyyy"
        /// Represents "yyyy-MM-dd"
        case yearMonthDay = "yyyy-MM-dd"
        /// Represent "MM-dd-yyyy"
        case monthDayYear = "MM-dd-yyyy"
        /// Represents "h:mm a"
        case twelveHourTime = "h:mm a"
        /// Represents "MMM dd"
        case shortMonthDay = "MMM dd"
        /// Represents "MMMM d"
        case longMonthShortDay = "MMMM d"
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

    /// Returns true if current date is "today".
    var isToday: Bool {
        return self.day == Date().day
    }

    /// Returns true if current date is "yesterday".
    var isYesterday: Bool {
        guard let today = Date().day else { return false }

        var dateComponents = DateComponents()
        dateComponents.setValue(-1, for: .day)
        let yesterday = Date.utcCalendar.date(byAdding: dateComponents, to: today)
        return self.day == yesterday
    }

    /// Returns true if current date is "tomorrow".
    var isTomorrow: Bool {
        guard let today = Date().day else { return false }

        var dateComponents = DateComponents()
        dateComponents.setValue(+1, for: .day)
        let tomorrow = Date.utcCalendar.date(byAdding: dateComponents, to: today)
        return self.day == tomorrow
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
    
    /// Returns a date with seconds cleared or set to zero.
    func clearSeconds() -> Date? {
        let dateComponents = Date.utcCalendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return Date.utcCalendar.date(from: dateComponents)
    }

    /// Returns a string of the date in the specified format
    func string(_ format: Format) -> String {
        let formatter = Date.formatter
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
    /// Returns date as a string in standard format.
    var standardString: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")

        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(from: self)
    }
    
    /// Returns date as a string in the format "H:MM:ss"
    var hourlyFormatString: String {
        let formatter = Date.formatter
        formatter.timeZone = .current
        formatter.dateFormat = "H:MM:ss"
        return formatter.string(from: self)
    }
    
    /// Returns a string of the expected timestamp in seconds
    func bybitTimestamp() -> String {
        let secondsConverted = String(NSDate().timeIntervalSince1970 * 1000).components(separatedBy: ".")
        return secondsConverted[0]
    }
}
