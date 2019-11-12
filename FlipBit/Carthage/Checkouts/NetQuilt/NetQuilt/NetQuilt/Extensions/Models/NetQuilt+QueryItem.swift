//
//  NetQuilt+QueryItem.swift
//  NetQuilt
//
//  Created by Daniel Stewart on 10/5/19.
//  Copyright © 2019 Daniel Stewart. All rights reserved.
//

import Foundation

public extension NetQuilt {
    /// A single name-value pair from the query portion of a URL.
    ///
    /// Foundation offers a `URLQueryItem` type but no a similar type for creating
    /// a HTTP header item. For consistency, `NetQuilt.HeaderItem` is matched with
    /// a type aliased `URLQueryItem` to `NetQuilt.QueryItem`
    typealias QueryItem = URLQueryItem
}
