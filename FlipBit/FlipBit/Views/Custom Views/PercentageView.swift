//
//  PercentageView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 12/7/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import UIKit

class PercentageView: View {
    
    lazy var button25: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("25%", for: .normal)
        button.setTitleColor(UIColor.Bybit.themeBlack, for: .normal)
        button.titleLabel?.font = .footnote
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var button50: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("50%", for: .normal)
        button.setTitleColor(UIColor.Bybit.themeBlack, for: .normal)
        button.titleLabel?.font = .footnote
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var button75: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("75%", for: .normal)
        button.setTitleColor(UIColor.Bybit.themeBlack, for: .normal)
        button.titleLabel?.font = .footnote
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var button100: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("100%", for: .normal)
        button.setTitleColor(UIColor.Bybit.themeBlack, for: .normal)
        button.titleLabel?.font = .footnote
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func setup() {
        super.setup()
        backgroundColor = UIColor.Bybit.white
        setBybitTheme()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(button25)
        addSubview(button50)
        addSubview(button75)
        addSubview(button100)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            
            button25.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.Space.margin4),
            button25.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin4),
            button25.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Dimensions.Space.margin4),
            button25.trailingAnchor.constraint(equalTo: button50.leadingAnchor),
            
            button50.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.Space.margin4),
            button50.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin4),
            button50.widthAnchor.constraint(equalTo: button25.widthAnchor),
            button50.trailingAnchor.constraint(equalTo: button75.leadingAnchor),
            
            button75.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.Space.margin4),
            button75.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin4),
            button75.widthAnchor.constraint(equalTo: button25.widthAnchor),
            button75.trailingAnchor.constraint(equalTo: button100.leadingAnchor),
            
            button100.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.Space.margin4),
            button100.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Dimensions.Space.margin4),
            button100.widthAnchor.constraint(equalTo: button25.widthAnchor),
            button100.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Dimensions.Space.margin4)
        ])
    }
    
    func configureButtonActions(viewController: ViewController, action: Selector, event: UIControl.Event) {
        button25.addTarget(viewController, action: action, for: event)
        button50.addTarget(viewController, action: action, for: event)
        button75.addTarget(viewController, action: action, for: event)
        button100.addTarget(viewController, action: action, for: event)
    }
}