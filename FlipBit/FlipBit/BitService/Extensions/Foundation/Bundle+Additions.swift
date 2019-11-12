//
//  Bundle+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

internal extension Bundle {
    /// List of Info Dictionary keys for retrieving bundle data.
    ///
    /// The naming convention follows `Identity` section of the `BitService` target.
    private struct InfoDictionaryKeys {
        /// The key for retrieving build version data from the main bundle using `CFBundleVersion`.
        static let build = "CFBundleVersion"
        
        /// The key for retrieving application name from the main bundle using `CFBundleExecutable`.
        static let displayName = "CFBundleExecutable"
        
        /// The key for retrieving application version data from the main bundle using `CFBundleShortVersionString`.
        static let version = "CFBundleShortVersionString"
    }
    
    /// The build version of the application using `BitService` framework.
    var build: String? {
        return infoDictionary?[InfoDictionaryKeys.build] as? String
    }
    
    /// The display name of the application using `BitService` framework.
    var displayName: String? {
        return infoDictionary?[InfoDictionaryKeys.displayName] as? String
    }
    
    /// The bundle identifier of the application using `BitService` framework.
    var identifier: String? {
        return bundleIdentifier
    }
    
    /// The version of the application using `BitService` framework.
    var version: String? {
        return infoDictionary?[InfoDictionaryKeys.version] as? String
    }
}
