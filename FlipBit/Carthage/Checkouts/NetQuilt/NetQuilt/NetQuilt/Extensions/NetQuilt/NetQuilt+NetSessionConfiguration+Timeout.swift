//
//  NetQuilt+NetSessionConfiguration+Timeout.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 9/28/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

internal extension NetQuilt.NetSessionConfiguration {
    /// Model object representing `URLSessionConfiguration` timeout intervals.
    struct Timeout {
        /// The time out interval to use when waiting for additional data.
        internal let request = 30.0
        
        /// The maximimum amount of time that a resource request should be allowed to take.
        internal let resource = 30.0
    }
}
