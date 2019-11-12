//
//  Data+Additions.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/13/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

/// Conforming `Data` type to `Model` protocol allows it to be used where `Model` is expected.
///
/// See `func execute<T: Model>(expecting type: completion:) -> Void) -> URLSessionDataTask?`
/// method implementation in `NetQuilt.NetSession`.
extension Data: Model { }
