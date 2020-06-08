//
//  InfoLabel.swift
//  FlipBit
//
//  Created by Daniel Stewart on 4/18/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class InfoLabel: BaseView {
    
    private lazy var titleLabel: UILabel = {
        UILabel(text: " ", font: UIFont.cambay, textColor: .white)
    }()
    
    private lazy var infoLabel: UILabel = {
        UILabel(text: " ", font: UIFont.cambayBold, textColor: .white, textAlignment: .right)
    }()
    
    init(title: String) {
        super.init(backgroundColor: themeManager.darkModeTheme)
        titleLabel.text = title
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(titleLabel)
        addSubview(infoLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
          //  make.leading.equalToSuperview().inset(Space.margin8)
            make.trailing.equalTo(self.snp.centerX)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(Space.margin8)
            make.leading.equalTo(self.snp.centerX)
        }
    }
    
    func configure(info: String) {
        infoLabel.text = info
    }
}
