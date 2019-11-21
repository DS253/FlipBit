//
//  TimeInterval+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/20/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation

extension TimeInterval {

    static let standardAnimationTime: TimeInterval = 0.4

    /// Returns properly formatted timer `string` when counting down or counting up.
    var timerString: String {
        let hours = abs(Int(self) / 3600)
        let minutes = abs(Int(self) / 60 % 60)

        return String(format: "%02i:%02i", hours, minutes)
    }
}
