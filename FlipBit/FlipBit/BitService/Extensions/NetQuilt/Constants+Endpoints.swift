//
//  Constants+Endpoints.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

internal typealias HeaderKeys = BitService.HeaderKeys
internal typealias HeaderValues = BitService.HeaderValues
internal typealias QueryKeys = BitService.QueryKeys

internal extension BitService {
    /// List of common header keys used by `BitService` endpoints.
    struct HeaderKeys {
        internal static let apiVersion = ""
        internal static let asgdsAAA = ""
        internal static let asgdsUsername = ""
        internal static let asgdsPassword = ""
        internal static let contentType = ""
        internal static let subscriptionKey = ""
    }
    
    /// List of common header values used by `BitService` endpoints.
    struct HeaderValues {
        internal static let apiVersion = ""
        internal static let contentType = ""
    }
    
    /// List of common query keys used by `BitService` endpoints.
    struct QueryKeys {
        internal static let action = ""
        internal static let arrivalAirportCode = ""
        internal static let confirmationCode = ""
        internal static let departureAirportCode = ""
        internal static let departureCity = ""
        internal static let departureDate = ""
        internal static let documentIdentifier = ""
        internal static let flightNumber = ""
        internal static let nameAssociatedId = ""
        internal static let passengerId = ""
        internal static let lastName = ""
    }
}
