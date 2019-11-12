//
//  NetQuilt+File.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/6/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

public extension NetQuilt {
    /// Model object representing a downloaded file.
    struct File {
        /// The binary representation of the downloaded file.
        public let data: Data
        
        /// The suggested filename by `URLResponse`.
        public let suggestedFilename: String?
        
        /// Creates a `File` instance given the provided parameter(s).
        ///
        /// - Parameters:
        ///   - data:               The binary representation of the downloaded file.
        ///   - suggestedFilename:  The suggested filename by `URLResponse`.
        public init(data: Data, suggestedFilename: String?) {
            self.data = data
            self.suggestedFilename = suggestedFilename
        }
    }
}
