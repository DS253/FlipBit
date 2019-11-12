//
//  BitService+Configuration.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/9/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

public extension BitService {
    /// A type that represents configuration object for the `BitService` instance.
    struct Configuration {
        /// The identity of the application using `BitService`.
        internal let application: BitService.Application
        
        /// Creates a `BitService` configuration given the provided parameters.
        public init() {
            self.application = BitService.Application()
        }
    }
}

