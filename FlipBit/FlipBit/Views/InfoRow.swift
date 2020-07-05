//
//  InfoRow.swift
//  FlipBit
//
//  Created by Daniel Stewart on 7/3/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class InfoRow: BaseView {
    
    private var leftLabel: InfoLabel

    private var rightLabel: InfoLabel
    
    private lazy var container: UIStackView = {
        UIStackView(axis: .horizontal, spacing: Space.margin16)
    }()
    
    init(left: InfoLabel, right: InfoLabel) {
        leftLabel = left
        rightLabel = right
        super.init(backgroundColor: themeManager.darkModeTheme)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        container.addArrangedSubviews([leftLabel, rightLabel])
        addSubview(container)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Space.margin16)
        }
        
        leftLabel.snp.makeConstraints { make in
            make.width.equalTo(rightLabel.snp.width)
        }
        
        rightLabel.snp.makeConstraints { make in
            make.width.equalTo(leftLabel.snp.width)
        }
    }
    
    func update(left: String? = nil, right: String? = nil) {
        if let leftText = left { leftLabel.configure(info: leftText) }
        
        if let rightText = right { rightLabel.configure(info: rightText) }
    }
}
