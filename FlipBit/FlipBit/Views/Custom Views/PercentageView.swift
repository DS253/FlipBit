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
        UIButton(title: "25%", textColor: themeManager.buyTextColor, font: .footnote)
    }()
    
    lazy var button50: UIButton = {
        UIButton(title: "50%", textColor: themeManager.buyTextColor, font: .footnote)
    }()
    
    lazy var button75: UIButton = {
        UIButton(title: "75%", textColor: themeManager.buyTextColor, font: .footnote)
    }()
    
    lazy var button100: UIButton = {
        UIButton(title: "100%", textColor: themeManager.buyTextColor, font: .footnote)
    }()
    
    override func setup() {
        super.setup()
        
        layer.borderColor = themeManager.buyTextColor.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 7.0
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
        
        button25.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(Space.margin4)
            make.trailing.equalTo(button50.snp.leading)
        }
        
        button50.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Space.margin4)
            make.trailing.equalTo(button75.snp.leading)
            make.width.equalTo(button25.snp.width)
        }
        
        button75.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Space.margin4)
            make.trailing.equalTo(button100.snp.leading)
            make.width.equalTo(button50.snp.width)
        }
        
        button100.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(Space.margin4)
            make.width.equalTo(button75.snp.width)
        }
    }
    
    func configureButtonActions(viewController: ViewController, action: Selector, event: UIControl.Event) {
        button25.addTarget(viewController, action: action, for: event)
        button50.addTarget(viewController, action: action, for: event)
        button75.addTarget(viewController, action: action, for: event)
        button100.addTarget(viewController, action: action, for: event)
    }
}
