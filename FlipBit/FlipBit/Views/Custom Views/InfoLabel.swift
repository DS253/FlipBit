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
        UILabel(text: " ", font: .footnote, textColor: .flatGray)
    }()
    
    private lazy var infoLabel: UILabel = {
        UILabel(text: "     ", font: .footnote, textColor: .white, textAlignment: .right)
    }()
    
    private lazy var container: UIStackView = {
        UIStackView(axis: .horizontal, spacing: 0.0)
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
        
        addSubview(container)
        container.addArrangedSubviews([titleLabel, infoLabel])
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(infoLabel.snp.width)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.width.equalTo(titleLabel.snp.width)
        }
    }
    
    func configure(info: String) {
        infoLabel.text = info
    }
}
