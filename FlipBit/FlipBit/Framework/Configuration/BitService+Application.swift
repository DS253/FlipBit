//
//  BitService+Application.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

internal extension BitService {
    /// A type that represents application using `BitService` framework.
    struct Application {
        /// The build version of the application using `BitService` framework.
        internal let build: String
        
        /// The environment of the application using `BitService` framework.
        internal let environment: BitService.Environment
        
        /// The bundle identifier of the application using `BitService` framework.
        internal let identifier: String
        
        /// The display name of the application using `BitService` framework.
        internal let name: String
        
        /// The version of the application using `BitService` framework.
        internal let version: String
        
        /// Creates a `Application` configuration given the provided parameters.
        internal init() {
            self.build = Bundle.main.build.unwrap({ "Application build version cannot be nil." })
            self.identifier = Bundle.main.identifier.unwrap({ "Application bundle identifier cannot be nil." })
            self.name = Bundle.main.displayName.unwrap({ "Application name cannot be nil." })
            self.version = Bundle.main.version.unwrap({ "Application version cannot be nil." })
            self.environment = BitService.Environment()
        }
    }
}
