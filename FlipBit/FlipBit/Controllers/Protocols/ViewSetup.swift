//
//  ViewSetup.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/18/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

/// The `ViewSetup` protocol provides an interface used to setup subviews and contraints in a repeatable sequence.
internal protocol ViewSetup {
    /// Use for setting up model related data & self layout.
    func setup()

    /// Use for setting up subviews.
    func setupSubviews()

    /// Use for setting up constraints.
    func setupConstraints()
}
