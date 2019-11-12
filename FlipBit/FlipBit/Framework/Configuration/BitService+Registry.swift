//
//  BitService+Registry.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

internal extension BitService {
    /// List of applications using `BitService` framework.
    ///
    /// Envisioned to help track applications that are actively using `BitService` framework.
    enum Registry {
        /// The Example app.
        case example

        /// The Lobby app.
        case lobby
    }
}

// MARK: Registered Identifiers

extension BitService.Registry {
    /// List of all quality assurance bundle identifiers registered with `BitService` framework.
    private var qualityAssuranceIdentifier: String {
        switch self {
        case .example:
            return "com.alaskaair.example.qa"
        case .lobby:
            return "com.alaskaair.enterprise.lobby.qa"
        }
    }
    
    /// List of all production bundle identifiers registered with `BitService` framework.
    private var productionIdentifier: String {
        switch self {
        case .example:
            return String()
        case .lobby:
            return "com.alaskaair.enterprise.lobby"
        }
    }
}

// MARK: CaseIterable

extension BitService.Registry: CaseIterable {
    /// Evaluates a given input string against all quality assurance bundle identifiers.
    ///
    /// - Parameters:
    ///   - identifier: The input string to evaluate.
    ///
    /// - Returns: True if input identifier is properly registered with `BitService`.
    internal static func isQualityAssuranceIdentifier(_ identifier: String) -> Bool {
        return allCases.compactMap { $0.qualityAssuranceIdentifier }.contains(identifier)
    }
    
    /// Evaluates a given input string against all production bundle identifiers.
    ///
    /// - Parameters:
    ///   - identifier: The input string to evaluate.
    ///
    /// - Returns: True if input identifier is properly registered with `GuestCore`.
    internal static func isProductionIdentifier(_ identifier: String) -> Bool {
        return allCases.compactMap { $0.productionIdentifier }.contains(identifier)
    }
}

