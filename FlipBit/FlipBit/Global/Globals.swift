//
//  Globals.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

/// Global Application instance.
internal let application = BitService.Application()

/// Global Service instance.
internal let service = BitService.Service()

/// Will wait the specified amount of time before executing completion.
internal func wait(_ time: DispatchTimeInterval, completion: @escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: completion)
}