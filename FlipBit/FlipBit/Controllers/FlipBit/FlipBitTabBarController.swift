//
//  FlipBitTabBarController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/20/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class FlipBitTabBarController: UITabBarController, ViewSetup {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupSubviews()
        setupConstraints()
    }
    
    func setup() {
    }
    
    func setupSubviews() {
//        tabBar.barTintColor = .red
        tabBar.alpha = 0.2
        tabBar.isUserInteractionEnabled = false
    }
    
    func setupConstraints() {
        
    }
}
