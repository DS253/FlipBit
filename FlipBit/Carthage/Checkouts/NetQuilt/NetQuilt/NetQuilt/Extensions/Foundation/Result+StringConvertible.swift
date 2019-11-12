//
//  Result+StringConvertible.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/13/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

extension Result: StringConvertible {
    internal var stringValue: String {
        switch self {
        case .failure:
            return "failure"
        case .success:
            return "success"
        }
    }
}
