//
//  NetQuiltError+StringConvertible.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/13/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

extension NetQuiltError: StringConvertible {
    internal var stringValue: String {
        switch self {
        case .decoder:
            return "decoder"
        case .data:
            return "data"
        case .requestable:
            return "requestable"
        case .response:
            return "response"
        case .session:
            return "session"
        case .unexpected:
            return "unexpected"
        case .unknown:
            return "unknown"
        }
    }
}
